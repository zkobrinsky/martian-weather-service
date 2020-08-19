require "pry"
require "net/http"
require "json"
require_relative "./latlong_creator"
require_relative "./martian_weather"
require_relative "./earth_weather"

class CLI

    attr_reader :lat, :long, :city, :state, :zip
    
    def initialize
        start
    end

    def start
        # welcome
        get_valid_zip
        EarthWeather.create_instances(@lat, @long, @city, @state)
        MartianWeather.create_instances
        compare_current_weather
    end

    def compare_current_weather
        temp = EarthWeather.all.first.avgtemp
        status = EarthWeather.all.first.status
        winddir = EarthWeather.all.first.winddir
        pres = EarthWeather.all.first.pres
        winsped = EarthWeather.all.first.avgws
        city = EarthWeather.all.first.city
        mars_avgtemp = MartianWeather.all.first.avgtemp
        mars_hitemp = MartianWeather.all.first.hightemp
        mars_lotemp = MartianWeather.all.first.lowtemp
        mars_winddir = MartianWeather.all.first.winddir
        mars_pres = MartianWeather.all.first.pres
        mars_winsped = MartianWeather.all.first.avgws
        

        puts "It is #{temp}°F with #{status} in your beautiful city of #{city}."
        puts "The wind is #{winsped}mph from the #{winddir}, with a lovely atmospheric pressure of #{pres} hPa."
        sleep(7)
        print "\n"
        print "\n"
        puts "On Mars it is #{mars_avgtemp}°F with a high of #{mars_hitemp}°F and a low of #{mars_lotemp}°F."
        puts "The wind is #{mars_winsped}mph from the #{mars_winddir}, with an atmospheric pressure of #{mars_pres} hPa."
        print "\n"
        print "\n"
        sleep(7)
        puts "It is cold."
        sleep(1)
        puts "It is desolate."
        sleep(1)
        puts "It is lonely."
        sleep(0.5)
        print "\n"
        5.times {loading_dots}
        print "\n"
        print "\n"
        puts "Where you are is beautiful."
        print "\n"
        sleep(2)
        puts "Cheer up."
        sleep(5)
        
       
        
        # binding.pry
    end


    def welcome
        puts "Welcome to the Martian Weather Service."
        sleep(0.6)
        5.times {loading_dots}
        sleep(0.3)
        print "Preparing quantum confibulators."
        sleep(0.8)
        print "\n"
        5.times {loading_dots}
        sleep(0.3)
        print "Charging atomic capacitors."
        sleep(1)
        print "\n"
        5.times {loading_dots}
        sleep(0.3)
        print "Transmitting to Mars."
        sleep(0.9)
        print "\n"
        5.times {loading_dots}
        sleep(0.3)
        print "Extraterrestrial transmission received."
        print "\n"
        sleep(1)
    end

    def loading_dots
        sleep(0.3)
        print "." 
    end

    def get_latlong(zip)
        latlong = LatLongCreator.create_latlong_from_zip(zip)
        if latlong != nil
            @lat = latlong[0]
            @long = latlong[1]
            @city = latlong[2]
            @state = latlong[3]
            @zip = zip
        else
            latlong = nil
        end
    end
    
    def get_valid_zip
        puts "Please enter your zip code."
        input = gets.chomp.to_i
        until get_latlong(input) != nil && input.to_s.length == 5
            puts "Please enter a valid U.S. zip code."
            input = gets.chomp.to_i
        end
    end

end

CLI.new