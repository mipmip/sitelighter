#!/usr/bin/env ruby

# A script that will pretend to resize a number of images
require 'optparse'
require 'sitelighterlib.rb'

options = {}

optparse = OptionParser.new do|opts|
    opts.banner = "Usage: optparse1.rb [options] file1 file2 ..."
    
    options[:action] = nil
    opts.on( '-a', '--action TEST/DOWNLOAD', 'Action to do' ) do|action|
        options[:action] = action
    end

    options[:server] = nil
    opts.on( '-b', '--localdir localdir', 'Localdir' ) do|localdir|
        options[:localdir] = localdir
    end
    
    options[:server] = nil
    opts.on( '-d', '--server serveraddress', 'Server address' ) do|server|
        options[:server] = server
    end
    
    options[:user] = nil
    opts.on( '-e', '--user FILE', 'Write log to FILE' ) do|user|
        options[:user] = user
    end     
    
    options[:pass] = nil
    opts.on( '-f', '--pass FILE', 'Write log to FILE' ) do|pass|
        options[:pass] = pass
    end     
    
    options[:path] = nil
    opts.on( '-g', '--path FILE', 'Write log to FILE' ) do|path|
        options[:path] = path
    end     
      
end

optparse.parse!

iwcconf = {}
iwcconf['localdir'] 			= options[:localdir]
iwcconf['ftpServer'] 			= options[:server]
iwcconf['ftpUser'] 				= options[:user]
iwcconf['ftpPass'] 				= options[:pass]
iwcconf['ftpPath'] 				= options[:path]

iwc = IWebbewiController.new
iwc.setConf(iwcconf)

if options[:action]=='download'
    begin
        p "refresh"
        iwc.refreshTempDir
        begin
            p "download"
            iwc.ftpDownloadTree
            rescue
            exit 2
        end
        rescue 
        exit 1
    end
    
    exit 0
end

if options[:action]=='test'
    begin
        iwc.testFTPConnectionSettings
        begin
            iwc.testFTPPathSettings
            rescue 
            exit 2
        end
        rescue
        exit 1
    end
    exit 0
end

if options[:action]=='applylightify'
    begin
        iwc.lightify
        rescue
        exit 1
    end
    exit 0
end


if options[:action]=='upload'
    begin
        iwc.curlUpload
        rescue
        exit 1
    end
    exit 0
end




