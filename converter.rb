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


# Ethihad partners
# Air Canada (AC)
# Air Europa (UX)
# Air France (AF)
# Air New Zealand (NZ)
# All Nippon Airways (NH)
# Asiana Airlines (OZ)
# Avianca (AV)
# Bangkok Airways (PG)
# FlexFlight (W2)
# Belavia (B2)
# brussels airlines (SN)
# China Eastern (MU)
# Egyptair (MS)
# EL AL Airlines (LY)
# Garuda Indonesia (GA)
# Gulf Air (GF)
# ITA Airways (AZ)
# JetBlue (B6)
# KLM (KL)
# Korean Air (KE)
# Lufthansa (LH)
# Middle East Air (ME)
# Royal Air Maroc (AT)
# SWISS International Air Lines (LX)
# Turkish Airlines (TK) 
# Virgin Australia (VA)


alliances = {
    'OneWorld' => ['Alaska Airlines', 'American Airlines', 'British Airways', 'Cathay Pacific', 'Finnair', 'Iberia', 'Japan Airlines',
        'Malaysia Airlines', 'Qantas', 'Qatar Airways', 'Royal Jordanian', 'Royal Air Morocco','Fiji ,Airways', 'Oman Air', 
        'SriLankan Airlines'],

    'Skyteam' => ['Aeroflot', 'Aerolíneas Argentinas', 'Aeroméxico', 'Air Europa', 'Air France', 'ITA Airways', 'China Airlines', 'China Eastern Airlines',
        'Czech Airlines', 'Delta AirLines', 'Garuda Indonesia', 'Kenya Airways', 'KLM', 'Korean Air', 'Middle East Airlines', 
        'Saudia', 'TAROM', 'Vietnam Airlines', 'Virgin Atlantic', 'Xiamen Airlines'],

    'Star Alliance' => ['Aegean Airlines', 'Air Canada','Air China', 'Air India', 'Air New Zealand', 'ANA','Asiana Airlines',
        'Austrian Airlines','Avianca','Brussels Airlines','Copa Airlines','Croatia Airlines','EGYPTAIR','Ethiopian Airlines',
        'EVA Air','LOT Polish Airlines','Lufthansa','Scandinavian Airlines','Shenzhen Airlines','Singapore Airlines',
        'South African Airways','Swiss','TAP Air Portugal','Thai Airways International','Turkish Airlines','United']
}

ccPrograms = {
    'CapitalOne' => ['Virgin Atlantic', 'TAP', 'Singapore Airlines', 'Qantas', 'Finnair', 'EVA Air', 'Ethihad', 'Emirates', 
        'British Airways', 'Avianca', 'Cathay Pacific', 'All Accor', 'Air Canada', 'Aeromexico'],
        
    'Chase' => ['Aer Lingus', 'Air Canada', 'British Airways', 'Emirates', 'Air France KLM', 'Iberia', 'JetBlue',
        'Singapore Airlines', 'Southwest', 'United', 'Cathay Pacific', 'Virgin Atlantic']
}

flightAirline = gets.chomp()
flightAlliance = false

alliances.each {|allianceName, alliancePartners|
    for member in alliancePartners do
        if member.downcase.include?(flightAirline.downcase)
            flightAlliance = allianceName
            break
        end     
    end
}

# try points transfer to partner airlines
allianceTransfer = false
if flightAlliance
    puts "#{flightAirline.capitalize} is part of #{flightAlliance}"
    puts "Check your booking options with points from these partner airlines #{alliances[flightAlliance]}"
    puts

    for alliancePartner in alliances[flightAlliance] do
        ccPrograms.each { |cardName, transferPartners|
            for transferPartner in transferPartners do
                if transferPartner.downcase.include?(alliancePartner.downcase) or alliancePartner.downcase.include?(transferPartner.downcase)
                    puts "You can transfer points to #{transferPartner} partner airline from #{cardName}" 
                    allianceTransfer = true
                end    
            end  
        }
    end  
else
    puts "#{flightAirline.capitalize} is not part of an alliance"    
end     
    
puts

foundTransferPartner = false

# try direct transfer
    ccPrograms.each { |cardName, transferPartners|
            for transferPartner in transferPartners do
                if transferPartner.downcase.include?(flightAirline.downcase) or flightAirline.downcase.include?(transferPartner.downcase)
                    also = 'also ' if allianceTransfer
                    
                    puts "You can #{also}transfer points directly to #{flightAirline.capitalize} from #{cardName}" 

                    foundTransferPartner = true
                end    
            end  
    }    
    puts "There are no direct credit card points transfer options for #{flightAirline.capitalize}" unless foundTransferPartner