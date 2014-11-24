# encoding: utf-8

##2014/11/20 - this class is used to import values from csv file to database

class ImportController < ApplicationController
    

    
    #to view to select file for import
    def import      
        #Model concern by the csv file
        session[:model]=params[:model]
        @key_word=import_type          
    end
    
    
    def upload
        #call insert method for the concerned model (model type store in session variable)
        #Object.const_get(session[:model]).import(params[:file])
  
        insert(params[:file])
        #Model concern by the csv file
        @key_word=import_type
        
        if @accounts.empty?
            flash[:notice] = 'Insertion réussie !'
            redirect_to :back
        else
            flash[:alert] = 'Doublons détectés !'
            
        end
 
        #redirect_to accounts_path
        #redirect_to :back
        
    end
    
    private
    
    #create model if it doesn't exist une DB, else store the duplicate model in hash
    def insert(file)
        if session[:model]=="Account"
            #create an array to store duplicate values
            @accounts=Array.new
            CSV.foreach(file.path, headers: true) do |row|
            #Account.create! row.to_hash
 
            @line=Account.new row.to_hash
                #search duplicate in base
                if !Account.where(company: @line[:company]).exists? && !Account.where(company: @line[:company].upcase).exists?
                    #if not duplicate
                    @line.save
                else
                    #if duplicate exist in base, store it in @accounts array
                    @accounts.push(@line)
                end
            end
            end
        respond_to do |format|
            format.html { @accounts = Kaminari.paginate_array(@accounts).page(params[:page]).per(10) }
        end
    end

    #this methode return the model type concerned by the import
    def import_type
        
        if session[:model]=="Account"
            key_word=t('app.controllers.Account').pluralize
        end
        return key_word
    end  
          
end
