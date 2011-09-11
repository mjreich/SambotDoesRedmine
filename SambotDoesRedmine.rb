class SambotDoesRedmine<SambotPlugin

  def initialize(sambot)
    super sambot
    load_config
    register({:terms => ["ticket \\d+"], :handler => 'run_ticket_info', :args => "ticket (\\w+)", :description => "Sam displays info about a redmine ticket."})    
    @host = @config['host']
  end
  
  def run_ticket_info(message, args)
    url = "/issues/#{args.first}.json?key="+@config['key']
    
    begin
      uri = URI.parse(@host+url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)

      resp = http.request(request)

      if resp.code == "200"
        result = JSON.parse(resp.body)
        output(message, @host+"/issues/"+result["issue"]["id"].to_s)
        output(message, format_ticket(result["issue"]))
      end
    rescue StandardError => e
      output(message, "Sorry, something went wrong (bad ticket id?).")
    end    
  end
  
  def format_ticket(ticket)
    output = ''
    output += "Title: "+ticket["subject"]+"\n"
    output += "Status: "+ticket["status"]["name"]+"\n" if ticket["status"]
    output += "Project: "+ticket["project"]["name"]+"\n"
    output += "Version: "+ticket["fixed_version"]["name"]+"\n" if ticket["fixed_version"]
    output += "Description: "+ticket["description"]+"\n" if ticket["description"]
    output += "Due Date: "+ticket["due_date"]+"\n" if ticket["due_date"]
    output += "Assigned To: "+ticket["assigned_to"]["name"]+"\n" if ticket["assigned_to"]
    output
  end
  
  def load_config
    @config = YAML::load_file(File.dirname(__FILE__) + "/../config/Redmine.yaml")
  end
  
  def output(message, msg)
    outmsg = SambotMessage.new(message.listener)
    outmsg.to = message.from
    outmsg.type = 'chat'
    outmsg.message = msg
    outmsg.send
  end  
end