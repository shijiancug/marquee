# run with: god -c /path/to/xxxx.god -D
# 
# This is the actual config file used to keep marquee server running.

FARM_SERVER_ROOT = "/home/activeworks/marquee_reload/marquee-web-main/farm_reload/server"

God.watch do |w|
  w.name = "farm-server-watcher"
  w.log = "#{FARM_SERVER_ROOT}/../../log/farm-server-watcher.log"
  w.interval = 30.seconds # default
  w.start = "cd #{FARM_SERVER_ROOT}; ruby server_control.rb start"
  w.stop = "cd #{FARM_SERVER_ROOT}; ruby server_control.rb stop"
  w.restart = "cd #{FARM_SERVER_ROOT}; ruby server_control.rb restart"
  w.start_grace = 30.seconds
  w.restart_grace = 30.seconds
  w.pid_file = "#{FARM_SERVER_ROOT}/server.rb.pid"
  
  w.behavior(:clean_pid_file)

  God::Contacts::Email.defaults do |d|
    d.from_email = 'marquee@active.com'
    d.from_name = 'Marquee farm server monitoring'
    d.delivery_method = :smtp
    d.server_host = 'mx1.dev.activenetwork.com'
    d.server_port = 25
  end

  God.contact(:email) do |c|
    c.name = 'Eric Yang'
    c.group = 'Marquee Team'
    c.to_email = 'eric.yang@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Tyrael Tong'
    c.group = 'Marquee Team'
    c.to_email = 'tyrael.tong@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Smart Huang'
    c.group = 'Marquee Team'
    c.to_email = 'smart.huang@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Leo Yin'
    c.group = 'Marquee Team'
    c.to_email = 'Leo.Yin@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Shawn Xu'
    c.group = 'Marquee Team'
    c.to_email = 'Shawn.Xu@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Brent Huang'
    c.group = 'Marquee Team'
    c.to_email = 'Brent.Huang@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Lynn Wang'
    c.group = 'Marquee Team'
    c.to_email = 'Lynnw.Wang@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Emma Wang'
    c.group = 'Marquee Team'
    c.to_email = 'Emma.Wang@activenetwork.com'
  end

  God.contact(:email) do |c|
    c.name = 'Sydney Zhang'
    c.group = 'Marquee Team'
    c.to_email = 'Sydney.Zhang@activenetwork.com'
  end

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 30.seconds
      c.running = false
      c.notify = {:contacts => ['Marquee Team'], :priority => 'Urgent', :category => 'production'}
    end
  end
  
  # w.restart_if do |restart|
  #   restart.condition(:http_response_code) do |c|
  #    c.host = 'localhost'
  #    c.port = 3000
  #    c.path = '/'
  #    c.timeout = 10.seconds
  #    c.times = [4, 5]
  #    c.code_is_not = 200
  #  end
  
  #  # restart.condition(:memory_usage) do |c|
  #  #   c.above = 150.megabytes
  #  #   c.times = [3, 5] # 3 out of 5 intervals
  #  # end
  
  #  # restart.condition(:cpu_usage) do |c|
  #  #   c.above = 50.percent
  #  #   c.times = 5
  #  # end
  # end
  
  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end