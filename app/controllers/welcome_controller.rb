class WelcomeController < ApplicationController
  def index
    hostname = 'web.awstechchallenge.com'
    source_ip = request.remote_ip
    uri = request.original_url
    params = request.parameters

    url_host = URI.parse(uri).host

    second_eni = 'eth1'

    bad_ip = '10.0.1.20'

    @response = url_host
    @test = params[:flag].class

    if params[:flag].nil?
        @test = 'html page'
        if !`curl #{source_ip}?flag=3 -H 'Host: web.awstechchallenge.com' -m 5 --head`.include? "200 OK"
            # Generate the checking code
            code = Base64.encode64(source_ip.reverse)[0..7]
            @response = "Nice! You have reached the server correctly! Please save the following string in /var/message of your Linux Server \n The string for you is  #{code}  \n\n The next task is to configure your Linux Server as NAT - All the HTTP requests that are sent to your Linux Server on port 80 should be forwarded to the WebServer. \n  After setting up the NAT, refresh the page to get the next instruction. "
        elsif `ping #{source_ip} -c 1 -I #{second_eni} -W 1`.include? "1 received"
            @response = "Cool! Now the requests are being forwarded correctly! \n\n  Hmmm... bad news, it seems that your linux Server is being scanned. It's likely that someone is doing hacky stuff. Find the IP of the bad guy and block it! \n After finishing this, refresh the page to proceed."
        else
            @response = 'Well done! You have finished all the tasks. Go hit "Finish" on the challenge to stop the timer!'
        end
    else
        case params[:flag]
            when '0'
                @test = 'flag is 0'
                @response =  `curl #{source_ip}?flag=3 -H 'Host: web.awstechchallenge.com'`rvm
            when '1'
                @test = 'flag is 1'
                # Directly specifying the IP of the ENI as somehow nmap -e doesn't work properly
                @response = `nmap #{source_ip} -S #{bad_ip}`
            when '2'
                @test = 'flag is 2'
                @response = `ping #{source_ip} -c 1 -I #{second_eni} -W 1`
            when '3'
                @test = 'flag is 3'
                @response = 'NATtingIsCorrect'
            else
                @test = 'undefined flag'
                @response = 'undefined flag'
        end

    end

  end



end
