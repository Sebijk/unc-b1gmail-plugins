<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
	
	<head>
		<meta http-equiv="content-type" content="text/html; charset={$charset}" />
		<script src="clientlang.php?sid={$sid}" type="text/javascript" language="javascript"></script>
		<script src="{$tpldir}js/common.js" type="text/javascript" language="javascript"></script>
		<script src="{$tpldir}js/loggedin.js" type="text/javascript" language="javascript"></script>
	</head>
	
	<body>
		<a href="{$url}" id="tctz_url">{$url}</a>
		<script type="text/javascript">
			function _redirect() {ldelim}
				document.location.href = "{$url}";
			{rdelim}
			
			function tctz_getDiffGMT() {ldelim}
				var rightNow = new Date();
				var date1 = new Date(rightNow.getFullYear(), 0, 1, 0, 0, 0, 0);
				var temp = date1.toGMTString();
				var date2 = new Date(temp.substring(0, temp.lastIndexOf(" ")-1));
				var hoursDiffStdTime = (date1 - date2) / (1000 * 60 * 60);
				return hoursDiffStdTime*60*60;
			{rdelim}
			
			MakeXMLRequest('start.php?action=tctz_set'
				+ '&offset=' + tctz_getDiffGMT()
				+ '&sid={$sid}',
				_redirect);
			EBID('tctz_url').style.display = 'none';
		</script>
	</body>
</html>