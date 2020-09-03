class MartianWeather
    attr_accessor :sol, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddir, :pres

    url = "https://api.nasa.gov/insight_weather/?api_key=dbgntr9dVwt1ol3Wdw5D8d7BTdEk5d208LElZEkA&feedtype=json&ver=1.0"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @@api_data = JSON.parse(response, symbolize_names: true)

    @@all = []
    @@forecast = []

    def initialize
    end

    def self.create_instances
        if @@api_data == !nil
            @@api_data.each do |s| 
                if s[0] != :sol_keys
                    if s[0] != :validity_checks
                        o = self.new
                        o.sol = s[0].to_s
                        o.date = s[1][:First_UTC].split("T").first
                        o.season = s[1][:Season]
                        o.avgtemp = o.c_to_f(s[1][:AT][:av]).round()
                        o.hightemp = o.c_to_f(s[1][:AT][:mx]).round()
                        o.lowtemp = o.c_to_f(s[1][:AT][:mn]).round()
                        o.avgws = o.mps_to_mph(s[1][:HWS][:av]).round()
                        # o.highws = o.mps_to_mph(s[1][:HWS][:mx]).round()
                        # o.lowws = o.mps_to_mph(s[1][:HWS][:mn]).round()
                        o.winddir = s[1][:WD][:most_common][:compass_point]
                        o.pres = o.pa_to_hpa(s[1][:PRE][:av]).round(2)
                        o.save
                    end
                end
            end
        else
            Get_DB_Data.get_martian_data.each do |s|
                o = self.new
                o.sol = s[:sol]
                o.date = s[:date]
                o.season = s[:season]
                o.avgtemp = s[:avgtemp]
                o.hightemp = s[:hightemp]
                o.lowtemp = s[:lowtemp]
                o.avgws = s[:avgws]
                # o.highws = s[:highws]
                # o.lowws = s[:lowws]
                o.winddir = s[:winddir]
                o.pres = s[:pres]
                o.save
            end
        end
    end


    def self.create_forecast
        #dependent on .create_instances having been called
        @@directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W",
                         "WNW", "NW", "NNW", "N"]
        if @@all.length == 7
            @@all.each.with_index(1) do |d, i|
                self.populate_forecast(d, i)
            end
        else
            i = 1
            d = @@all.last

            7.times do 
                self.populate_forecast(d,i)
                i += 1
            end
        end
    end

    def self.populate_forecast(d, i)
            o = self.new
            o.sol = (get_current_sol+i).to_s
            o.date = (Time.now+86400*i).to_s.split(" ").first
            o.season = @@all.last.season
            o.avgtemp = d.avgtemp+(rand(-10..10))
            o.hightemp = d.hightemp+(rand(-10..10))
            o.lowtemp = d.lowtemp+(rand(-10..10))
            o.avgws = d.avgws+(rand(-10..10))
            # o.highws = d.highws+(rand(-10..10))
            # o.lowws = d.lowws+(rand(-10..10))
            # o.winddir = @@directions[rand(0..@@directions.length-1)]
            o.winddir = @@all.last.winddir
            o.pres = (d.pres+(rand(1..5))).round(2)
            @@forecast << o
    end

    def self.get_current_sol
        today_sol = @@all.last.sol.to_i + (Time.now.yday - Time.parse(@@all.last.date).yday) + 1
        # adjusts for Martian new year window:
        if today_sol > 668
            today_sol = today_sol - 668
        else
            today_sol
        end
    end

    def self.sort_by_date
        @@all.sort_by{|i| i.date}
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def self.forecast
        @@forecast
    end

    def pa_to_hpa(pa)
        pa/100
    end

    def c_to_f(c)
        (c*9/5)+32
    end

    def mps_to_mph(m)
        m*2.237
    end


end


