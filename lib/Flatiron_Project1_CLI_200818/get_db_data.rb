class Get_DB_Data
    def self.get_martian_data
        weather_data = []
        sql = <<-SQL
        SELECT * FROM martian_weather
        SQL
        DB[:conn].execute(sql).each do |d|
            weather_hash = {}
            d.each_with_index do |w, i|
                weather_hash[DB[:conn].execute('PRAGMA table_info(martian_weather)')[i][1].to_sym] = w
            end
            weather_data << weather_hash
        end
        weather_data
    end

    def self.add_values_to_db(date_to_ignore)
        sql = <<-SQL
            IF NOT EXISTS
            (SELECT * FROM martian_weather WHERE date = ?)
            BEGIN
            INSERT INTO martian_weather 
            (avgtemp, date, hightemp, lowtemp, pres, season, sol, winddir, avgws, status) 
            VALUES (-86, '2020-09-09', 02, -135, 7.8, 'summer', '605', 'WNW', 19, 'cold and desolate')
            END
        SQL

        # sql = <<-SQL
        # INSERT INTO martian_weather 
        # (avgtemp, date, hightemp, lowtemp, pres, season, sol, winddir, avgws, status) 
        # VALUES (-86, '2020-09-09', 02, -135, 7.8, 'summer', '605', 'WNW', 19, 'cold and desolate') 
        # WHERE NOT EXISTS (SELECT * FROM martian_weather WHERE date = "2020-09-09")
        # SQL
        DB[:conn].execute(sql, date_to_ignore)
    end

end