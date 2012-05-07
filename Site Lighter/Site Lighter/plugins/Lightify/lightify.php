<?php

/* CONFIGURATION */

print_r($argv[1]);

$directory = $argv[1];

/* END CONFIGURATION */

$lightifyMeta='<meta name="lightify" content="1" />';

$pattern = array('/<\/head>/m','/onPageLoad\(\);/m');
$replace = array('<meta name="lightify" content="1" /><link rel="stylesheet" href="lightbox/lightbox.css" type="text/css" media="screen" /><script type="text/javascript" src="lightbox/lightbox.js"></script></head>','onPageLoad(); initLightbox();');

// create a handler for the directory
$handler = opendir($directory);

// open directory and walk through the filenames
while ($file = readdir($handler)) {
	$lightified=false;
	$newlines=array();
	if (substr($file,-4)=='html' && $file != "index.html"  && $file != "." && $file != "..") {
		if($fh = fopen($directory.'/'.$file,"r")){
			while (!feof($fh)){
				$line=fgets($fh,9999);
				if(substr(trim($line),0,strlen($lightifyMeta))==$lightifyMeta)
				{
					$lightified=true;
				}
					
				$newlines[] = preg_replace($pattern, $replace,$line);
			} 
			fclose($fh); 

			if(!$lightified)
			{
				echo "writing $file\n<br/>";

				file_put_contents($directory.'/'.$file, $newlines);
				unset($lightified);
			}
			else
			{
				echo $file;
				echo " Allready lightified\n";
			}
		} 
	}
}

closedir($handler);

echo "\n Lightify had finished\n";
exit(0);
?>
