require 'uri'
require 'net/http'
require 'openssl'
require 'time'
require 'json'

class Flight
  attr_accessor :number, :airline, :from, :to, :duration, :price, :stop, :arrivalTime, :departureTime, :layoverTime
  def initialize number, airline, from, to, duration, departureTime, arrivalTime, price
      @number = number
      @airline = airline
      @from = from
      @to = to
      @duration = duration
      @departureTime = departureTime
      @arrivalTime = arrivalTime
      @price = price
  end
end

usaHubs = ['LAX', 'SFO', 'SEA', 'SAN', 'PHX', 'DFW', 'ATL', 'DEN', 'ORD', 'CLT', 'MCO', 'LAS', 'MIA', 'IAH', 'JFK', 'ERW', 'FLL', 'MSP', 'DTW', 'BOS', 'SLC', 'PHL', 'BWI', 'TPA', 'LGA', 'MDW', 'BNA', 'IAD']
canadaHubs = ['YYC', 'YHZ', 'YUL', 'YOW', 'YQB', 'YYZ', 'YVR']
latinHubs = ['MEX', 'CUN', 'GRU', 'MID', 'MVD', 'BOG', 'LPB', 'VVI', 'MDE', 'SCL', 'LIM', 'CGH', 'BSB', 'GIG', 'PTY', 'AEP', 'GDL', 'EZE', 'CNF', 'MTY', 'VCP', 'SDU', 'POA', 'REC', 'SSA', 'TIJ', 'CWB', 'FOR', 'HAV', 'SJO', 'MUN', 'FLN', 'BEL', 'CUZ', 'GYN', 'VIX', 'SAL', 'CGB', 'COR', 'MAO', 'GUA', 'NAT', 'IGU', 'MCZ', 'MDZ', 'BPS', 'AQP', 'SLZ', 'MGA', 'LIR', 'ASU', 'BZE', 'SAP', 'TGU', 'ACA', 'MGF', 'PMW']
euroHubs = ['AMS', 'LHR', 'CDG', 'MAD', 'FRA', 'MUC', 'BCN', 'SVO', 'FCO', 'DUB', 'LGW', 'ORY', 'VIE', 'ATH', 'LED', 'PMI', 'LIS', 'OSL', 'ZRH', 'CPH', 'DME', 'MXP', 'BRU', 'VKO', 'ARN', 'MAN', 'STN', 'BER', 'AGP', 'HEL', 'WAW', 'DUS', 'GVA', 'LPA', 'AER', 'LIN', 'LTN', 'OVB', 'BGO', 'OPT', 'NCE', 'OPO', 'EDI', 'HAM', 'MRS', 'TFN', 'BUD', 'VCE', 'BHX', 'LYS', 'NAP', 'BGY', 'PRG', 'STR', 'BLQ', 'TLS', 'VLC', 'IBZ']
afroHubs = ['JNB', 'CAI', 'CPT', 'CMN', 'ADD', 'ALG', 'NBO', 'LOS', 'TUN', 'DUR', 'RAK', 'HRG', 'MIR', 'MRU', 'ABV', 'ACC', 'SSH', 'DAR', 'LAD', 'KRT', 'DKR', 'MBA', 'ZNZ']
arabHubs = ['DXB', 'DOH', 'JED', 'AUH', 'RUH', 'KWI', 'BHR', 'TLV', 'AMM', 'AQJ', 'BEY']
asiaHubs = ['EVN', 'GYD', 'NAY', 'PEK', 'PVG', 'SHA', 'HKG', 'BLR', 'BOM', 'DEL', 'CGK', 'KIX', 'NGO', 'NRT', 'FRU', 'MFM', 'KUL', 'ULN', 'KTM', 'MNL', 'TPE', 'GMP', 'ICN', 'SIN', 'DAM', 'DMK', 'HKT', 'TAS', 'HAN']
oceaniaHubs = ['SYD', 'MEL', 'AKL']


from = 'IAD'
to = 'AUH'
date = '2024-11-26'
minimumLayover = 120
firstLegFlights = []
secondLegFlights = []

hubs = euroHubs

puts 
puts "Looking for flights between #{from} and #{to} on #{date}..."

def get_itineraries (from, to, date)
    url = URI("https://priceline-com-provider.p.rapidapi.com/v2/flight/departures?sid=iSiX639&departure_date=#{date}&adults=1&origin_airport_code=#{from}&destination_airport_code=#{to}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '4cbb773a81mshe1b1e072787d514p1ef2d9jsn2f821eb78eda'
    request["X-RapidAPI-Host"] = 'priceline-com-provider.p.rapidapi.com'

    response = http.request(request)
    results = response.body
    json = JSON.parse(results)
    json['message']
    unless json['getAirFlightDepartures']['error'] 
      return itineraries = json['getAirFlightDepartures']['results']['result']['itinerary_data']
    end
    return nil
end

def pick_direct_flight(itineraries)
  directFligths = []
  for itinerary in itineraries do
    connections_count = itinerary[1]['slice_data']['slice_0']['info']['connection_count']
    if connections_count < 1 
      flightNumber = itinerary[1]['slice_data']['slice_0']['flight_data']['flight_0']['info']['flight_number']
      price = itinerary[1]['price_details']['display_total_fare'].round(0)
      origin = itinerary[1]['slice_data']['slice_0']['departure']['airport']['code']
      destination = itinerary[1]['slice_data']['slice_0']['arrival']['airport']['code']
      duration = itinerary[1]['slice_data']['slice_0']['info']['duration']
      duration = duration[3..4].to_i*60 + duration[6..7].to_i
      airline = itinerary[1]['slice_data']['slice_0']['airline']['name']
      departureTime = Time.parse(itinerary[1]['slice_data']['slice_0']['departure']['datetime']['time_24h'])
      arrivalTime = Time.parse(itinerary[1]['slice_data']['slice_0']['arrival']['datetime']['time_24h'])
      directFligths << Flight.new(flightNumber, airline, origin, destination, duration, departureTime, arrivalTime, price)
    end
  end 
  return directFligths
end

itineraries = get_itineraries(from, to, date)
bestFlight = pick_direct_flight(itineraries)[0]

puts
puts "Direct flight between #{bestFlight.from} and #{bestFlight.to} is available:"
puts "Flight number: #{bestFlight.number}"
puts "Airline: #{bestFlight.airline}"
puts "Flight duration: #{Float(bestFlight.duration/60).round(2)} hours"
puts "Price: $#{bestFlight.price.round(0)}"

for hub in hubs
  unless from == hub
    itineraries = get_itineraries(from, hub, date)
    if itineraries
      flights = pick_direct_flight(itineraries) 
      if flights.size > 0
        firstLegFlights += flights
      end
    end
  end
end

for each in firstLegFlights
    unless each.to == to
      itineraries = get_itineraries(each.to, to, date)
      if itineraries
        flights = pick_direct_flight(itineraries) 
        if flights.size > 0
          secondLegFlights += flights
        end
      end  
    end
end

for firstFlight in firstLegFlights
  for secondFlight in secondLegFlights
    if firstFlight.to == secondFlight.from
      totalPrice = firstFlight.price + secondFlight.price
      layover = (secondFlight.departureTime - firstFlight.arrivalTime)/60
      if bestFlight.price > totalPrice and layover > minimumLayover
        bestFlight.stop = firstFlight.to
        bestFlight.duration = firstFlight.duration + secondFlight.duration
        bestFlight.number = firstFlight.number + ' + ' + secondFlight.number
        bestFlight.airline = firstFlight.airline + ' + ' + secondFlight.airline
        bestFlight.price = totalPrice.round(0)
        bestFlight.layoverTime = layover.round(0)
        break
      end  
    end  
  end  
end

puts 
if bestFlight.stop
  puts "Found a cheaper route with #{bestFlight.layoverTime} minutes layover in #{bestFlight.stop}:"
  puts "Flight numbers: #{bestFlight.number}"
  puts "Airlines: #{bestFlight.airline}"
  puts "In air time: #{Float(bestFlight.duration/60).round(2)} hours"
  puts "Price: $#{bestFlight.price}"
else
  puts "No cheaper route is available"
end  