require 'rubygems'
require 'json'
require 'nokogiri'   
require 'open-uri'
require "google_drive"

page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))   

get_townhall_email = page.css('a[class = "lientxt"]').map{|a| "http://annuaire-des-mairies.com/"+ a["href"].gsub("./","")}

mairie = Hash.new

get_townhall_email.each {|x| 
    url = Nokogiri::HTML(open(x)) 
    email = url.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
    town = url.xpath("/html/body/div/main/section[1]/div/div/div/h1").text
    mairie[town] = email
}

File.open("email.json","w") do |f|
    f.write(mairie.to_json) #hash atsofoka ao anat json
end

session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1zKXHxtF52AL8ZlZaBsvERz8QtQtDiQy6FdJC_Kn0UOg").worksheets[0]
i = 2
mairie.each { |k, v|
    ws[i, 1] = k
	ws[i, 2] = v
	i += 1
}
        
ws.save