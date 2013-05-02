#!/usr/bin/env ruby
# encoding utf-8
require 'json'
class CORM_Object < Hash

    @@path = './config/CORM.json'

    def self.createObject(json_object, depth, key_as_sym = true)
        
        o = depth == 0 ? CORM_Object.new : Hash.new
        if (key_as_sym)
            json_object.each do |k, v|
                if (json_object[k].is_a? Hash)
                    o[k.to_sym] = self.createObject(v, depth+1, key_as_sym)
                else
                    o[k.to_sym] = v[0] == ':' ? v[1..v.length].to_sym : v
                end
                
            end
        else
            json_object.each do |k, v|
                if (json_object[k].is_a? Hash)
                    o[k] = self.createObject(v, depth+1, key_as_sym)
                else
                    o[k] = v[0] == ':' ? v[1..v.length].to_sym : v
                end
                
            end
        end
        return o
    end

    def self.get
        if (!File.exists?(@@path))
            throw Exception.new('The file ./config/CORM.json does not exists')
        end
        corm_json_string = File.read(@@path)
        json_object = JSON.parse(corm_json_string);
        return self.createObject(json_object, 0)
    end

    def get_version
        version = self[:version].split(' ')
        versionsSplitted = version[0].split('.')
        return {
            major: versionsSplitted[0].to_i,
            minor: versionsSplitted[1].to_i,
            corrected: versionsSplitted[2].to_i,
            build: version[1]
        }
    end
    
    def set_version(o)
        if (o.is_a? String)
            version = self[:version].split(' ')
            version[0] = o
            self[:version] = version.join(' ')
        elsif (o.is_a? Hash)
            version = self[:version].split(' ')
            versionsSplitted = version[0].split('.')
            if (!o[:build].nil?)
                version[1] = o[:build]
            end
            versionsSplitted[0] = o[:major]
            versionsSplitted[1] = o[:minor]
            versionsSplitted[2] = o[:corrected]
            self[:version] = versionsSplitted.join('.').concat(version[1])
        
        end
    end
    
    def save(path)
        if (path.nil?)
           path = @@path
        end
        json = self.to_json
        json_o = JSON.parse(json)
        json = JSON.pretty_generate(json_o)
        File.open(path, 'w') do |f|
            f.write(json)
        end
    end

end