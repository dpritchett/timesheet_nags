require 'net/http'
require 'json'
require 'date'

module TimesheetNags
  # Growl me if my timesheets are outdated
  class Nagger
    def check_and_nag
      if should_nag?
        send_nag("Your timesheet is out of date 😭 Age: #{latest_timestamp_age} days.", is_good: false)
      else
        maybe_compliment 'You rock at timesheets!'
      end
    end

    def maybe_compliment(message)
      return unless rand(10).eql?(5)
      send_nag message
    end

    def should_nag?
      tuesday_through_friday = [2,3,4,5]
      day_of_week = Date.today.to_time.wday
      latest_timestamp_age > 0 && tuesday_through_friday.include?(day_of_week)
    end

    def latest_timestamp_age
      sheet = latest_timesheets.first
      stamp = sheet.fetch('spent_date')

      (Date.today - Date.parse(stamp)).to_i
    end

    def send_nag(nag = 'Your timesheets are a mystery!', is_good: true)
      if is_good
        args = "osascript -e 'display notification \" 💚 #{nag} 💚 \" with title \"Time Sheet Update\"'"
      else
        args = "osascript -e 'display notification \" 🛑 #{nag} 🛑 \" with title \"Time Sheet Update\"'"
      end
      IO.popen(args).close
    end

    def latest_timesheets
      uri = URI('https://api.harvestapp.com/v2/time_entries')

      req = Net::HTTP::Get.new(uri)

      req['Authorization'] = 'Bearer ' + ENV.fetch('HARVEST_TOKEN')
      req['Harvest-Account-Id'] = ENV.fetch('HARVEST_ACCOUNT_ID')

      begin
      @_res ||= Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, timeout: 2) do |http|
        http.request(req)
      end
      rescue SocketError
        abort "Unable to connect to Harvest!"
      end

      res = @_res

      raise StandardError, "Bad HTTP request: #{res.body}" unless res.code == '200'

      body = res.body
      parsed = JSON.parse(body)

      parsed.fetch('time_entries')
    end

    def age_of_timestamp(line)
      last_log_date = Date.parse(line)

      age = (Date.today - last_log_date).to_i

      day_of_week = Date.today.to_time.wday

      if age < 2
        puts 'Time log status: good'
      elsif day_of_week < 2
        puts "No new logs, but it's a monday"
      else
        puts 'Start a new time log, dummy'
      end
    end
  end
end
