#!/usr/bin/ruby
require 'rubygems'
require 'net/ftp'
require 'fileutils'

class IWebbewiController
    
	def setConf(conf)
		@conf = conf
		@FTPURL 	 		= conf['ftpServer']
		@FTPUsername		= conf['ftpUser']
		@FTPPasswd 	 		= conf['ftpPass']
		@RemoteDirectory 	= conf['ftpPath']
		@localdir 			= conf['localdir']
	end
    
	def refreshTempDir
		if(File.directory? @localdir) 
			FileUtils.rm_r(@localdir)
		end
		FileUtils.mkdir(@localdir)
  		FileUtils.cp_r File.dirname(__FILE__) +'/plugins/Lightify/lightbox', @localdir+"/"
	end
    
	def testFTPConnectionSettings
        p "info: test connection"
		begin
			ftp=Net::FTP.new
            p "info: new connection"
			ftp.connect(@FTPURL,21)
            p "info: open connection"
			ftp.login(@FTPUsername,@FTPPasswd)
            p "info: login"
			ftp.close
            p "info: close connection"
			true
            rescue
			raise "Could not establish FTP connection, wrong server of credentials"
			false
		end
	end
	
	def testFTPPathSettings
        p "info: test path"
		begin
			ftp=Net::FTP.new
            p "info: new connection"
			ftp.connect(@FTPURL,21)
            p "info: open connection"
			ftp.login(@FTPUsername,@FTPPasswd)
            p "info: login"
			ftp.chdir(@RemoteDirectory)
            p "info: chdir"
			ftp.mkdir('testDir')
            p "info: mkdir"
			ftp.rmdir('testDir')
            p "info: rmdir"
			ftp.close
            p "info: close connection"
            true
            rescue
			raise "Could not establish FTP connection, wrong path of not writable"
			false
		end
	end
    
	def ftpDownloadTree
		begin
			ftp=Net::FTP.new
			ftp.connect(@FTPURL,21)
			ftp.login(@FTPUsername,@FTPPasswd)
			ftp.chdir(@RemoteDirectory)
			filenames = ftp.nlst('*.html') 
			p filenames
            
			filenames.each{|filename| 
				ftp.getbinaryfile(filename,@localdir+'/'+filename) 
			}
			ftp.close
            rescue
			raise "FTP error, check all settings"
		end
        
	end
    
	def curlUpload
        system("cd #{@localdir};pwd; find . -type f -exec curl -u #{@FTPUsername}:#{@FTPPasswd} --ftp-create-dirs -T {} ftp://#{@FTPURL}#{@RemoteDirectory}/{}" + ' \;')
	end
    
	def lightify
		p File.dirname(__FILE__) +"/plugins/Lightify/Lightify.php"
		system("php '" + File.dirname(__FILE__) +"/plugins/Lightify/Lightify.php' #{@localdir}")
	end

end
