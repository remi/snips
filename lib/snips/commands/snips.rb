class Snip::Bin

  # CAT
  def self.cat_help
    <<doco
Usage: snip cat SNIP

  Summary:
    prints out the full source of a snip
doco
  end
  def self.cat *snip
    snip = snip.shift
    if snip
      out = $SNIP_MANAGER.read( snip )
      puts (out.nil?) ? "snip not found: #{snip}" : out
    else
      help :cat
    end
  end

  # LIST
  def self.list_help
    <<doco
Usage: snip list

  Summary:
    prints a list of all available snips
doco
  end
  def self.list *no_args
    puts $SNIP_MANAGER.list
  end

  # WHICH
  def self.which_help
    <<doco
Usage: snip which SNIP

  Summary:
    displays the full path to the snip
doco
  end
  def self.which *snip
    snip = snip.shift
    if snip
      out = $SNIP_MANAGER.which( snip )
      puts (out.nil?) ? "snip not found: #{snip}" : out
    else
      help :which
    end
  end

  # SERVER
  def self.server_help
    <<doco
Usage: snip server [repo-path]

  Runs a snip server hosting the snips 
  from your local install_repo or from 
  a repo specified

  Summary:
    starts up a snip server
doco
  end
  def self.server *args
    options = { :Port => 5000, :repo => $SNIP_MANAGER.install_repo.location }
    OptionParser.new { |opts| 
      opts.on('-p','--port [PORT]'){ |port| options[:Port] = port.to_i }
    }.parse!( args )
  
    options[:repo] = args.first unless args.empty?
    
    Snip::Server.new( options[:repo] ).run options
  end

  # INSTALL
  def self.install_help
    <<doco
Usage: snip install SNIP

  Summary:
    installs a snip on your local system
doco
  end
  def self.install *snip
    snip = snip.shift
    if snip
      installed = $SNIP_MANAGER.install( snip )
      puts (installed) ? "installed #{snip}" : "snip '#{snip}' was not installed"
    else
      help :install
    end
  end

  # UNINSTALL
  def self.uninstall_help
    <<doco
Usage: snip uninstall SNIP

  Summary:
    uninstalls a snip from your system
doco
  end
  def self.uninstall *snip
    snip = snip.shift
    if snip
      uninstalled = $SNIP_MANAGER.uninstall( snip )
      puts (uninstalled) ? "uninstalled #{snip}" : "snip '#{snip}' was not uninstalled"
    else
      help :uninstall
    end
  end

  class << self
    alias remove uninstall
    def remove_help
      <<doco
Usage: snip remove SNIP

  Summary:
    alias for uninstall
doco
    end
  end

  # RUN
  def self.run_help
    <<doco
Usage: snip run SNIP

  Be sure to add a #! shabang line to your snip
  if you want it to be usable via 'snip run'

  Summary:
    executes the SNIP, if installed locally.
doco
  end
  def self.run *snip
    snip = snip.shift
    if snip
      which = $SNIP_MANAGER.which( snip )
      if which.nil?
        puts "snip not found: #{snip}"
      else
        if File.file?which
          unless File.executable?which
            File.chmod 0755, which
          end
          if File.executable?which
            system which
          else
            puts "cannot execute file: #{which}"
          end
        else
          puts "snip not installed locally: #{snip}"
          puts "try:"
          puts "      snip install #{snip}"
          puts "or    snip run_remote #{snip}"
        end
      end
    else
      help :run
    end
  end

end
