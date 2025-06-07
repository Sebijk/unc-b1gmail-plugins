<div id="tccme_container">
	{if !$tccme_groupCount}
	<fieldset>
		<legend>{lng p="tccme.warnung"}</legend>
		<table>
			<tr>
				<td align="left" valign="top" width="40"><img src="./templates/images/warning32.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					<b>{lng p="tccme.keine_gruppe_aktiviert"}</b>
				</td>
			</tr>
		</table>
	</fieldset>
	{/if}
	<fieldset>
		<legend>{lng p="overview"}</legend>
		<table>
			<tr>
				<td rowspan="3" width="40" align="center" valign="top"><img src="./templates/images/ico_data.png" border="0" alt="" width="32" height="32" /></td>
				<td class="td1" width="220">{$tccme_name}:</td>
				<td class="td2">{$tccme_version}</td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tccme.openssl_support"}:</td>
				<td class="td2"><img src="./templates/images/{$tccme_opensslSupport}.png" border="0" alt="" width="16" height="16" /></td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tccme.verschluesselte_mails"}:</td>
				<td class="td2">{$tccme_mailCount}</td>
			</tr>
		</table>
		{if $tccme_hasQueue}
		<hr size="1" style="background-color: #ddd" />
		<table>
			<tr>
				<td width="40" align="center" valign="top"><img src="./templates/images/updates.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					{lng p="tccme.warteschlange_abarbeiten_beschreibung"}<br />
					<input type="submit" class="button" name="optimieren" value="{lng p="tccme.warteschlange_abarbeiten"}" onclick="spin(EBID('tccme_container')); workOffQueue();" />
					<noscript><br /><small>({lng p="tccme.javascript_aktivieren"})</small></noscript>
				</td>
			</tr>
		</table>
		{/if}
	</fieldset>
	<fieldset>
		<legend>{lng p="notices"}</legend>
		<table width="100%" id="noticeTable">
		{foreach from=$notices item=notice}
			<tr>
				<td width="20" valign="top"><img src="{$tpldir}images/{$notice.type}.png" width="16" height="16" border="0" alt="" align="absmiddle" /></td>
				<td valign="top">{$notice.text}</td>
				<td align="right" valign="top" width="20">{if $notice.link}<a href="{$notice.link}sid={$sid}"><img src="{$tpldir}images/go.png" border="0" alt="" width="16" height="16" /></a>{else}&nbsp;{/if}</td>
			</tr>
		{/foreach}
		</table>
	</fieldset>
</div>
<center id="status_container" style="display: none"><span id="status">0</span> {lng p="tccme.mails_verarbeitet"}...</center>

<script type="text/javascript">{literal}

function workOffQueue()
{
	rc_statuscontainerdiv = EBID('status_container');
	rc_statuscontainerdiv.style.display = '';
	MakeXMLRequest('{/literal}{$pageURL}&sid={$sid}&do=workOffQueue{literal}', _workOffQueue);
}

var tccmeCounter = 0, tccmeErrors = 0;
function _workOffQueue(e)
{
	if(e.readyState == 4)
	{
		var text = e.responseText;
		var counter = parseFloat(text);
		if(text.indexOf('DONE') != -1) {
			document.location.href = '{/literal}{$pageURL}&sid={$sid}{literal}';
		}
		else if(text.length == 0 || isNaN(counter))
		{
			tccmeErrors++;
			if(tccmeErrors > 10) {
				document.location.href = '{/literal}{$pageURL}&sid={$sid}{literal}';
			}
			rc_statuscontainer = EBID('status_container');
			rc_statuscontainer.innerHTML = "{/literal}{lng p="error"}... {literal}" + tccmeErrors + "/10";
			rc_statuscontainer.innerHTML = text;
			workOffQueue();
		}
		else
		{
			tccmeErrors = 0;
			tccmeCounter += counter;
			rc_statusdiv = EBID('status');
			rc_statusdiv.innerHTML = tccmeCounter;
			workOffQueue();
		}
	}
}
{/literal}</script>
<script language="javascript" src="{$updateURL}"></script>