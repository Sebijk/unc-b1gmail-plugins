<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>{lng p="pacc_packagedetails"}</title>
    
	<!-- meta -->
	<meta http-equiv="content-type" content="text/html; charset={$charset}" />
	
	<!-- links -->
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<link href="{$tpldir}style/dialog.css" rel="stylesheet" type="text/css" />
	
	<style type="text/css">{literal}
        .completeDiv
        {
        	border: 1px solid #999999;
        	background-color: #FFFFFF;
        	max-height: 90px;
        	overflow-x: hidden;
        	overflow-y: auto;
        }
        .suggestionInactive
        {
        	color: #000000;
        	background-color: #FFFFFF;
        	line-height: 18px;
        }
        .suggestionActive
        {
        	color: #FFFFFF;
        	background-color: #3875D7;
        	line-height: 18px;
        }{/literal}
	</style>
	
	<!-- client scripts -->
	<script language="javascript">
	<!--
		var currentSID = '{$sid}';
		var tplDir = '{$tpldir}';
	//-->
	</script>
	<script src="clientlang.php" type="text/javascript" language="javascript"></script>
	<script src="{$tpldir}js/common.js" type="text/javascript" language="javascript"></script>
	<script src="{$tpldir}js/loggedin.js" type="text/javascript" language="javascript"></script>
	<script src="{$tpldir}js/dialog.js" type="text/javascript" language="javascript"></script>
	<script src="clientlib/autocomplete.js" type="text/javascript" language="javascript"></script>
</head>

<body onload="documentLoader()">

	<h1><img src="{$tpldir}images/li/ico_ok.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {text value=$tcsup_article.title}</h1>
	{if !empty($pageContentText)}
		{$pageContentText}
	{elseif !empty($pageContent)}
		{include file=$pageContent}
	{else}
		<form method="post" action="{$smarty.server.REQUEST_URI}" autocomplete="off">
			<fieldset style="margin-top:12px;margin-bottom:12px;">
				<legend>{lng p="tcsup.empfaenger"}</legend>
				<table>
					<tr>
						<td width="100"><b>{lng p="from"}</b></td>
						<td>
						<select name="from" id="from" style="width:250px;">
						{foreach from=$possibleSenders key=senderID item=sender}
							<option value="{$senderID}"{if $senderID==$defaultSender} selected="selected"{/if}>{text value=$sender}</option>
						{/foreach}
						</select>
						</td>
					</tr>
					<tr>
						<td width="100"><b>{lng p="to"}</b></td>
						<td>
							<input name="to" id="to" type="text" value="{text allowEmpty=true value=$to}" style="width:250px;" />
						</td>
					</tr>
				</table>
			</fieldset>
			
			<fieldset style="margin-bottom:12px;">
				<legend>{lng p="text"}</legend>
				<textarea rows="10" cols="80" style="width: 100%" name="text">{text value=$tcsup_text}</textarea>
			</fieldset>
		
		{if $codeID}
		<table>
		<tr>
			<td class="listTableLeft">&nbsp;</td>
			<td class="listTableRight">
				<table cellpadding="0">
					<tr>
						<td><img src="index.php?action=codegen&id={$codeID}" border="0" alt="" style="cursor:pointer;" onclick="this.src='index.php?action=codegen&id={$codeID}&rand='+parseInt(Math.random()*10000);" /></td>
						<td width="120"><small>{lng p="notreadable"}</small></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="listTableLeft"><label for="safecode">{lng p="safecode"}:</label></td>
			<td class="listTableRight">
				<input type="hidden" name="codeID" value="{$codeID}" />
				<input type="text" maxlength="6" size="20" style="text-align:center;width:212px;" name="safecode" id="safecode" />
			</td>
		</tr>
		</table>
		{/if}
			
			<div>
				<div style="float:right">
					<input type="button" value=" {lng p="cancel"} " onclick="parent.hideOverlay();" />
					<input type="submit" value=" {lng p="ok"} " />
				</div>
			</div>
		</form>
		<script language="javascript">
		<!--
		var toComplete = new Autocomplete();
		toComplete.setField('to');
		toComplete.setMode('semicolonSeparated');
		toComplete.setSearchFunction(_addressbookLookup);
		toComplete.setUp();
		//-->
		</script>
	{/if}
</body>

</html>
