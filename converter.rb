# Emirates
# Can have extended stopover in Dubai
# https://fly2.emirates.com/CAB/IBE/SearchAvailability.aspx

# Can book flights operated by

# Quantas 
# United 
# AirCanada (bi-directional) (North America)
# Aegean (Greece)
# Air Baltic (between Dubai and Riga, within Baltic)
# Air Mauritius
# Avianca

directPartners = {
    'Etihad' => ['Air Canada', 'Air Europa', 'Air France KLM', 'Air New Zealand', 'All Nippon Airways', 'Asiana Airlines', 'Avianca',
        'Bangkok Airways', 'FlexFlight', 'Belavia', 'Brussels Airlines', 'China Eastern', 'Egyptair', 'EL AL Airlines', 'Garuda Indonesia',
        'Gulf Air', 'ITA Airways', 'JetBlue', 'Korean Air', 'Lufthansa', 'Middle East Air', 'Royal Air Maroc', 'SWISS',
        'Turkish Airlines', 'Virgin Australia']
}

alliances = {
    'OneWorld' => ['Alaska Airlines', 'American Airlines', 'British Airways', 'Cathay Pacific', 'Finnair', 'Iberia', 'Japan Airlines',
        'Malaysia Airlines', 'Qantas', 'Qatar Airways', 'Royal Jordanian', 'Royal Air Morocco','Fiji Airways', 'Oman Air', 
        'SriLankan Airlines'],

    'Skyteam' => ['Aeroflot', 'Aerolíneas Argentinas', 'Aeroméxico', 'Air Europa', 'Air France KLM', 'ITA Airways', 'China Airlines',
        'China Eastern Airlines','Czech Airlines', 'Delta AirLines', 'Garuda Indonesia', 'Kenya Airways', 'Korean Air', 
        'Middle East Airlines', 'Saudia', 'TAROM', 'Vietnam Airlines', 'Virgin Atlantic', 'Xiamen Airlines'],

    'Star Alliance' => ['Aegean Airlines', 'Air Canada','Air China', 'Air India', 'Air New Zealand', 'ANA','Asiana Airlines',
        'Austrian Airlines','Avianca','Brussels Airlines','Copa Airlines','Croatia Airlines','EGYPTAIR','Ethiopian Airlines',
        'EVA Air','LOT Polish Airlines','Lufthansa','Scandinavian Airlines','Shenzhen Airlines','Singapore Airlines',
        'South African Airways','Swiss','TAP Air Portugal','Thai Airways International','Turkish Airlines','United']
}

cards = {
    'Capital One' => ['Virgin Atlantic', 'TAP', 'Singapore Airlines', 'Qantas', 'Finnair', 'EVA Air', 'Etihad', 'Emirates', 
        'British Airways', 'Avianca', 'Cathay Pacific', 'All Accor', 'Air Canada', 'Aeromexico'],
        
    'Chase' => ['Aer Lingus', 'Air Canada', 'British Airways', 'Emirates', 'Air France KLM', 'Iberia', 'JetBlue',
        'Singapore Airlines', 'Southwest', 'United', 'Cathay Pacific', 'Virgin Atlantic']
}

puts "What is your desired flight airline name?"
flightAirline = gets.chomp().downcase

sterilizedFlightAirline = flightAirline.sub(' airlines','').sub(' airways','')     
capitalizedFlightAirline = flightAirline.split.map(&:capitalize).join(' ') 

def member_of_array(airlineName, array)
    for member in array do
        return true if member.downcase.include?(airlineName.downcase)
    end  

    return false   
end

flightAlliance = false
alliances.each {|allianceName, alliancePartners|
    if member_of_array(sterilizedFlightAirline, alliancePartners)
        flightAlliance = allianceName
        break
    end
}

# try points transfer to alliance partner
if flightAlliance
    puts "\n#{capitalizedFlightAirline} is part of #{flightAlliance}.\n\nCheck these partner airlines to potentially book this flight with respective miles:"
    for each in alliances[flightAlliance] do 
        print each + ', '
    end    
    puts
    puts

    for alliancePartner in alliances[flightAlliance] do
        cards.each { |cardName, transferPartners|
            puts "You can transfer #{cardName} points to #{alliancePartner}"  if member_of_array(alliancePartner,transferPartners)
        }
    end  
else
    puts "#{capitalizedFlightAirline} is not a member of an alliance"    
end     
    
puts

cards.each { |cardName, transferPartners|
    # puts sterilizedFlightAirline, cardName, transferPartners
    if member_of_array(sterilizedFlightAirline, transferPartners)
        puts "You can transfer #{cardName} points directly to #{capitalizedFlightAirline}" 
    else 
        # puts "You can't convert #{cardName} points directly to #{capitalizedFlightAirline} miles." 
    end
}    

puts
directPartners.each{|airline, partners|
    if airline.downcase == sterilizedFlightAirline
        puts "You can also potentially book with points from one of #{capitalizedFlightAirline} partners:\n"
        for each in partners
            print each + ', '
        end    

        puts "\n\n"
        for partner in partners do
            cards.each { |cardName, transferPartners|
                if member_of_array(partner, transferPartners)
                    puts "You can transfer #{cardName} points directly to #{partner}" 
                else 
                    # puts "You can't convert #{cardName} points to #{partner} miles." 
                end
            }    
        end 
    end 
}