
<table cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td><h1><img src="{$tpldir}images/li/menu_ico_{$folderInfo.type}.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {$folderInfo.title}</h1></td>
		<td align="center">
			<small>
			{if $folderInfo.type!='intellifolder'}
				<a onclick="return(confirm('{lng p="realempty"}'));" href="email.php?do=emptyFolder&folder={$folderID}&sid={$sid}"><img src="{$tpldir}images/li/folder_empty.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="emptyfolder"}</a>
				&nbsp; &nbsp;
			{/if}
				<a href="start.php?action=tcbms_search&amp;sid={$sid}&amp;sort={$sortColumn}&amp;order={$sortOrder}&amp;q={text value=$q}"><img src="{$tpldir}images/li/refresh.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="refresh"}</a>
			</small>
		</td>
		<td align="right" valign="middle">
			<a href="javascript: advancedOptions('view', 'right', 'bottom', '{$tpldir}');">
				<img id="advanced_view_arrow" src="{$tpldir}images/li/mini_arrow_right.gif" border="0" alt="" align="absmiddle" /> {lng p="viewoptions"}
			</a>
		</td>
	</tr>
</table>

<div id="advanced_view_body" style="display:none;">
<form action="start.php?action=tcbms_search&amp;sid={$sid}&amp;sort={$sortColumn}&amp;order={$sortOrder}&amp;q={text value=$q}" method="post">
<table class="listTable">
	<tr>
		<th class="listTableHead" colspan="3"> {lng p="viewoptions"}</th>
	</tr>
	<tr>
		<td class="listTableLeft"><label for="perpage">{lng p="mails_per_page"}</label>:</td>
		<td class="listTableRight"><select name="perpage" id="perpage">
			{section start=5 step=5 loop=55 name=num}
			<option value="{$smarty.section.num.index}"{if $perPage==$smarty.section.num.index} selected="selected"{/if}>{$smarty.section.num.index}</option>
			{/section}
		</select></td>
	</tr>
	<tr>
		<td class="listTableLeft">&nbsp;</td>
		<td class="listTableRight"><input type="submit" value="{lng p="ok"}" />
									<input type="reset" value="{lng p="reset"}" /></td>
	</tr>
</table>
</form><br />
</div>

<div>
<form action="start.php?action=tcbms_search&sid={$sid}&sort={$sortColumn}&order={$sortOrder}" method="post" onsubmit="document.location.href = this.action + '&js=1&q=' + (encodeURIComponent(EBID('tcbms_search_q').value)) + '&spam=' + (encodeURIComponent(EBID('tcbms_search_spam').checked ? 1 : 0)); return false;">
<table class="listTable">
	<tr>
		<th class="listTableHead" colspan="3"> {lng p="search"}</th>
	</tr>
	<tr>
		<td class="listTableLeft"><label for="tcbms_search_q">{lng p="tcbms.suchbegriff"}</label>:</td>
		<td class="listTableRight" width="50"><input id="tcbms_search_q" type="text" name="q" value="{text value=$q allowEmpty=1}" size="40" /></td>
		<td class="listTableRight"><input id="tcbms_search_spam" type="checkbox" name="spam" value="1"{if $searchSpam} checked="checked"{/if} /><label for="tcbms_search_spam"> {lng p="tcbms.spam_durchsuchen"}</label></td>
	</tr>
	<tr>
		<td class="listTableLeft">&nbsp;</td>
		<td class="listTableRight"><input type="submit" value="{lng p="tcbms.suchen"}" />
									<input type="reset" value="{lng p="reset"}" /></td>
		<td class="listTableRight">&nbsp;</td>
	</tr>
</table>
</form><br />
</div>

<form name="f1" action="email.php?do=action&action=folder&sid={$sid}" method="post">
<table class="listTable">
	<tr>
		<th class="listTableHead" width="20"><input type="checkbox" id="allChecker" onclick="checkAll(this.checked, document.forms.f1);" /></th>
		<th class="listTableHead" width="50"><img src="{$tpldir}images/li/mail_markunread.png" width="16" height="16" border="0" alt="" /></th>
		<th class="listTableHead" width="20%">
		{if $folderID!=-2}
			<a href="start.php?action=tcbms_search&q={$qUrl}&sid={$sid}&sort=von&order={$sortOrderInv}&spam={$searchSpam}">{lng p="from"}</a>
			{if $sortColumn=='von'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		{else}
			<a href="start.php?action=tcbms_search&q={$qUrl}&sid={$sid}&sort=an&order={$sortOrderInv}&spam={$searchSpam}">{lng p="to"}</a>
			{if $sortColumn=='an'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		{/if}</th>
		<th class="listTableHead">
			<a href="start.php?action=tcbms_search&q={$qUrl}&sid={$sid}&sort=betreff&order={$sortOrderInv}&spam={$searchSpam}">{lng p="subject"}</a>
			{if $sortColumn=='betreff'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="130">
			<a href="start.php?action=tcbms_search&q={$qUrl}&sid={$sid}{if $tcbms_prefs.engine == "mysql"}&sort=score&order={$sortOrderInv}{/if}&spam={$searchSpam}">{lng p="tcbms.wahrscheinlichkeit"}</a>
			{if $sortColumn=='score'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="130">
			<a href="start.php?action=tcbms_search&q={$qUrl}&sid={$sid}&sort=fetched&order={$sortOrderInv}&spam={$searchSpam}">{lng p="date"}</a>
			{if $sortColumn=='fetched'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="65">
			<a href="start.php?action=tcbms_search&q={$qUrl}&sid={$sid}&sort=size&order={$sortOrderInv}&spam={$searchSpam}">{lng p="size"}</a>
			{if $sortColumn=='size'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="70">&nbsp;</th>
	</tr>
	
	{if $mailList}
	{assign var=first value=true}
	{foreach from=$mailList key=mailID item=mail}
	{cycle values="listTableTD,listTableTD2" assign="class"}
	
	{if $mailID<0}
	{cycle values="listTableTD,listTableTD2" assign="class"}
	{if !$first}
	</tbody>
	{/if}
	<tr>
		<td colspan="7" class="folderGroup">
			<a style="display:block;" href="javascript:toggleGroup({$mailID});">&nbsp;<img id="groupImage_{$mailID}" src="{$tpldir}images/contract.gif" border="0" align="absmiddle" alt="" />
			&nbsp;{$mail.text} {if $mail.date && $mail.date!=-1}({date timestamp=$mail.date dayonly=true}){/if}</a>
		</td>
	</tr>
	<tbody id="group_{$mailID}" style="display:;">
	{assign var=first value=false}
	{else}
	<tr>
		<td class="{$class}" nowrap="nowrap"><input type="checkbox" name="mail_{$mailID}" /></td>
		<td class="{$class}" nowrap="nowrap">
			<img id="mail_{$mailID}_flagimg" src="{$tpldir}images/li/mailico_{if $mail.flags&16}flagged{elseif $mail.priority==1}high{elseif $mail.priority==-1}low{else}empty{/if}.gif" border="0" alt="" /><img src="{$tpldir}images/li/mailico_{if $mail.flags&64}attachment{else}empty{/if}.gif" border="0" alt="" /><img src="{$tpldir}images/li/mailico_{if $mail.flags&4}forwarded{elseif $mail.flags&2}answered{else}empty{/if}.gif" border="0" alt="" />
		</td>
		{if $folderID!=-2}
		<td class="{if $sortColumn=='von'}listTableTDActive{else}{$class}{/if}" nowrap="nowrap"><span id="mail_{$mailID}_span1" class="{if $mail.flags&1}un{/if}readMail"><a href="javascript:void(0);" onclick="currentEMail='{$mail.from_mail}';currentEMailID={$mailID};showAddressMenu(event,true);">
			&nbsp;{if $mail.from_name}{text value=$mail.from_name cut=25}{else}{text value=$mail.from_mail cut=20}{/if}
		</a></span>&nbsp;</td>
		{else}
		<td class="{if $sortColumn=='an'}listTableTDActive{else}{$class}{/if}" nowrap="nowrap"><span id="mail_{$mailID}_span1" class="{if $mail.flags&1}un{/if}readMail"><a href="javascript:void(0);" onclick="currentEMail='{$mail.to_mail}';currentEMailID={$mailID};showAddressMenu(event,true);">
			&nbsp;{if $mail.to_name}{text value=$mail.to_name cut=25}{else}{text value=$mail.to_mail cut=20}{/if}
		</a></span>&nbsp;</td>
		{/if}
		<td class="{if $sortColumn=='betreff'}listTableTDActive{else}{$class}{/if}" nowrap="nowrap">&nbsp;{if $mail.flags&128}<img src="{$tpldir}images/li/infected.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {/if}{if $mail.flags&256}<img src="{$tpldir}images/li/spam.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {/if}<span id="mail_{$mailID}_span2" class="{if $mail.flags&1}un{/if}readMail"><a {if $folderID!=-3}{if $enablePreview} href="javascript:void(0);" onclick="togglePreviewPane({$mailID}, '{$tpldir}', '{$sid}')" ondblclick="document.location.href='email.read.php?id={$mailID}&sid={$sid}';"{else} href="email.read.php?id={$mailID}&sid={$sid}"{/if}{else}href="email.compose.php?redirect={$mailID}&sid={$sid}"{/if}>{text value=$mail.subject cut=30}</a></span>&nbsp;</td>
		<td class="{if $sortColumn=='score'}listTableTDActive{else}{$class}{/if}" nowrap="nowrap">&nbsp;{$mail.score*100|string_format:"%.2f"}%&nbsp;</td>
		<td class="{if $sortColumn=='fetched'}listTableTDActive{else}{$class}{/if}" nowrap="nowrap">&nbsp;{date timestamp=$mail.timestamp nice=true}&nbsp;</td>
		<td class="{if $sortColumn=='size'}listTableTDActive{else}{$class}{/if}" nowrap="nowrap">&nbsp;{size bytes=$mail.size}&nbsp;</td>
		<td class="{$class}" nowrap="nowrap">
			<a href="email.read.php?id={$mailID}&sid={$sid}"><img src="{$tpldir}images/li/mail_read.png" width="16" height="16" border="0" alt="{lng p="read"}" /></a>
			<a href="javascript:void(0);" onclick="currentSID='{$sid}';currentID={$mailID};showMailMenu(event);"><img src="{$tpldir}images/li/ico_menu.png" width="16" height="16" border="0" alt="{lng p="mail_menu"}" /></a>
			<a href="email.php?do=deleteMail&id={$mailID}&{$folderString}&sid={$sid}"{if $folderID==-5} onclick="return(confirm('{lng p="realdel"}'));"{/if}><img src="{$tpldir}images/li/ico_delete.png" width="16" height="16" border="0" alt="{lng p="delete"}" /></a>
		</td>
	</tr>
	{/if}
	{/foreach}
	{if !$first}
	</tbody>
	{/if}
	{/if}
	
	<tr>
		<td colspan="8" class="listTableFoot">
			<table cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td align="left">
						<select class="smallInput" name="massAction">
							<option value="-">------ {lng p="selaction"} ------</option>
							
							<optgroup label="{lng p="actions"}">
								<option value="delete">{lng p="delete"}</option>
								<option value="forward">{lng p="forward"}</option>
								<option value="download">{lng p="download"}</option>
							</optgroup>
							
							{if $tcbms_prefs.engine == "mysql"}
							<optgroup label="{lng p="flags"}">
								<option value="markread">{lng p="markread"}</option>
								<option value="markunread">{lng p="markunread"}</option>
								<option value="mark">{lng p="mark"}</option>
								<option value="unmark">{lng p="unmark"}</option>
								<option value="markspam">{lng p="markspam"}</option>
								<option value="marknonspam">{lng p="marknonspam"}</option>
							</optgroup>
							{/if}
							
							<optgroup label="{lng p="move"}">
							{foreach from=$folderList item=folder}
							{if !$folder.intelligent && $folder.id!=-3}<option value="moveto_{$folder.id}">{lng p="moveto"} &quot;{$folder.text}&quot;</option>{/if}
							{/foreach}
							</optgroup>
						</select>
						<input class="smallInput" type="submit" value="{lng p="ok"}" />
					</td>
					<td align="center">
						{lng p="pages"}: {pageNav page=$pageNo pages=$pageCount on=" <b>[.t]</b> " off=" <a class=\"pageNav\" href=\"start.php?action=tcbms_search&q=$qUrl&sid=$sid&sort=$sortColumn&order=$sortOrder&spam=$searchSpam&page=.s\">.t</a> "}
					</td>
					<td align="right">
						{if $enablePreview}<a href="javascript: togglePreviewPane(-1, '{$tpldir}', '{$sid}');">
							<img id="preview_pane_arrow" src="{$tpldir}images/li/mini_arrow_right.gif" border="0" alt="" align="absmiddle" /> {lng p="previewpane"}
						</a>{else}&nbsp;{/if}
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<!-- mail menu -->
<div id="mailMenu" class="mailMenu" style="display:none;position:absolute;left:0px;top:0px;">
	<a class="mailMenuItem" href="javascript:document.location.href='email.read.php?id='+currentID+'&sid='+currentSID;"><img align="absmiddle" src="{$tpldir}images/li/mail_read.png" width="16" height="16" border="0" alt="" /> {lng p="mail_read"}</a>
	<a class="mailMenuItem" href="javascript:printMail(currentID, currentSID);"><img align="absmiddle" src="{$tpldir}images/li/mail_print.png" width="16" height="16" border="0" alt="" /> {lng p="print"}</a>
	<div class="mailMenuSep"></div>
	<a class="mailMenuItem" href="javascript:document.location.href='email.compose.php?reply='+currentID+'&sid='+currentSID;"><img align="absmiddle" src="{$tpldir}images/li/mail_reply.png" width="16" height="16" border="0" alt="" /> {lng p="reply"}</a>
	<a class="mailMenuItem" href="javascript:document.location.href='email.compose.php?forward='+currentID+'&sid='+currentSID;"><img align="absmiddle" src="{$tpldir}images/li/mail_forward.png" width="16" height="16" border="0" alt="" /> {lng p="forward"}</a>
	<a class="mailMenuItem" href="javascript:document.location.href='email.compose.php?redirect='+currentID+'&sid='+currentSID;"><img align="absmiddle" src="{$tpldir}images/li/mail_redirect.png" width="16" height="16" border="0" alt="" /> {lng p="redirect"}</a>
	<div class="mailMenuSep"></div>
	<a class="mailMenuItem" href="javascript:folderFlagMail(currentID, 1, false);"><img align="absmiddle" src="{$tpldir}images/li/mail_markread.png" width="16" height="16" border="0" alt="" /> {lng p="markread"}</a>
	<a class="mailMenuItem" href="javascript:folderFlagMail(currentID, 1, true);"><img align="absmiddle" src="{$tpldir}images/li/mail_markunread.png" width="16" height="16" border="0" alt="" /> {lng p="markunread"}</a>
	<div class="mailMenuSep"></div>
	<a class="mailMenuItem" href="javascript:folderFlagMail(currentID, 16, true);"><img align="absmiddle" src="{$tpldir}images/li/mailico_flagged.gif" width="16" height="16" border="0" alt="" /> {lng p="mark"}</a>
	<a class="mailMenuItem" href="javascript:folderFlagMail(currentID, 16, false);"><img align="absmiddle" src="{$tpldir}images/li/mailico_empty.gif" width="16" height="16" border="0" alt="" /> {lng p="unmark"}</a>
	<div class="mailMenuSep"></div>
	<a class="mailMenuItem" href="javascript:showMailSource(currentID);"><img align="absmiddle" src="{$tpldir}images/li/mail_source.png" width="16" height="16" border="0" alt="" /> {lng p="showsource"}</a>
	<div class="mailMenuSep"></div>
	<a class="mailMenuItem" href="javascript:if(confirm('{lng p="realdel"}')) document.location.href='email.php?do=deleteMail&id='+currentID+'&{$folderString}&sid='+currentSID;"><img align="absmiddle" src="{$tpldir}images/li/mail_delete.png" width="16" height="16" border="0" alt="" /> {lng p="mail_del"}</a>
</div>

<div id="preview_pane" style="display:none;">

	<br />
	<table class="listTable">
		<tr>
			<th class="listTableHead">{lng p="preview"}</th>
		</tr>
		<tr>
			<td><iframe width="100%" height="350" src="about:blank" id="preview_frame" frameborder="0" scrolling="auto"></iframe></td>
		</tr>
	</table>	

</div>

{if $refreshInterval>0}
<script language="javascript">
<!--
	initInboxRefresh({$refreshInterval});
//-->
</script>
{/if}

{include file="li/email.addressmenu.tpl"}
