#encoding: utf-8

#this class represent an account imported by a csv file and waiting for valitation

class ImportAccount < ActiveRecord::Base
  extend ToCsv
  resourcify
  paginates_per 10
  
  before_save :uppercase_company
  
  belongs_to :user
  belongs_to :author_user, :foreign_key => 'created_by', :class_name => 'User'
  belongs_to :editor_user, :foreign_key => 'modified_by', :class_name => 'User'
  belongs_to :import
  
  # Help to sort by criteria
  scope :by_company_like, lambda { |company| where("UPPER(company) LIKE UPPER(?)",  "%#{company}%") unless company.blank? }
  
  def author
    return author_user || User::default
  end
  
  def editor
    return editor_user || User::default
  end
  
  def uppercase_company
    if !self.company.nil?
        UnicodeUtils.upcase(self.company, I18n.locale)
    end
   
  end

  def full_adress
	tmp = self.adress1
	if !tmp==nil? && !self.adress2.blank?
		tmp += ', ' + self.adress2
	end
	if !tmp==nil? && !self.zip.blank?
		tmp += ', ' + self.zip
	end
	if !tmp==nil? && !self.city.blank?
		tmp += ', ' + self.city
	end	
	return tmp
  end
  
end
