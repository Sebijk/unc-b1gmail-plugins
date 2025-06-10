<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>{$service_title}{if $pageTitle} - {text value=$pageTitle}{/if}</title>
    
	<!-- meta -->
	<meta http-equiv="content-type" content="text/html; charset={$charset}" />
	
	<!-- links -->
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<link href="{$tpldir}style/dialog.css" rel="stylesheet" type="text/css" />
	
</head>

<body{if !$tcsup_notPrint} onload="self.print()"{/if} style="background-color: white;">
	<h1><i class="fa fa-check" aria-hidden="true"></i> {text value=$tcsup_article.title}</h1>
	<br />
	{$tcsup_article.body}
</body>
</html>