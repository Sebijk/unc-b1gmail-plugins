<div id="tcbms_container">
	{if !$tcbms_groupCount}
	<fieldset>
		<legend>{lng p="welcome"}</legend>
		<table>
			<tr>
				<td align="left" valign="top" width="40"><img src="../plugins/templates/images/search32.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					{lng p="tcbms.willkommen_text"}
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset>
		<legend>{lng p="tcbms.warnung"}</legend>
		<table>
			<tr>
				<td align="left" valign="top" width="40"><img src="./templates/images/warning32.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					<b>{lng p="tcbms.keine_gruppe_aktiviert"}</b>
				</td>
			</tr>
		</table>
	</fieldset>
	{/if}
	<fieldset>
		<legend>{lng p="overview"}</legend>
		<table>
			<tr>
				<td rowspan="5" width="40" align="center" valign="top"><img src="./templates/images/ico_data.png" border="0" alt="" width="32" height="32" /></td>
				<td class="td1" width="220">{$tcbms_name}:</td>
				<td class="td2">{$tcbms_version}</td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tcbms.unicode_support"}:</td>
				<td class="td2"><img src="./templates/images/{if @preg_match('/\pL/u', 'a')}ok{else}warning{/if}.png" border="0" alt="" width="16" height="16" /></td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tcbms.indexierte_mails"}:</td>
				<td class="td2">{$tcbms_index_anzahl}</td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tcbms.index_groesse"}:</td>
				<td class="td2">{size bytes=$tcbms_index_groesse}</td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tcbms.index_letzt_optimierung"}:</td>
				<td class="td2">{date timestamp=$tcbms_prefs.index_optimieren_zeit_zuletzt nice=true nozero=true}</td>
			</tr>
		</table>
		<hr size="1" style="background-color: #ddd" />
		<table>
			<tr>
				<td width="40" align="center" valign="top"><img src="./templates/images/db_optimize.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					{lng p="tcbms.jetzt_optimieren"}<br />
					<input type="submit" class="button" name="optimieren" value="{lng p="tcbms.index_optimieren"}" onclick="spin(EBID('tcbms_container')); optimizeIndex();" />
					<noscript><br /><small>({lng p="tcbms.javascript_aktivieren"})</small></noscript>
				</td>
			</tr>
		</table>
		<hr size="1" style="background-color: #ddd" />
		<table>
			<tr>
				<td width="40" align="center" valign="top"><img src="./templates/images/updates.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					{lng p="tcbms.jetzt_regenerieren"}<br />
					<input type="submit" class="button" name="regenerieren" value="{lng p="tcbms.index_regenerieren"}" onclick="{if !$tcbms_groupCount}alert('{lng p="tcbms.keine_gruppe_aktiviert"}');{else}spin(EBID('tcbms_container')); regenerateIndex();{/if}" />
					<noscript><br /><small>({lng p="tcbms.javascript_aktivieren"})</small></noscript>
				</td>
			</tr>
		</table>
		<hr size="1" style="background-color: #ddd" />
		<table>
			<tr>
				<td width="40" align="center" valign="top"><img src="./templates/images/tempfiles.png" border="0" alt="" width="32" height="32" /></td>
				<td>
					{lng p="tcbms.jetzt_loeschen"}<br />
					<form action="{$pageURL}&sid={$sid}&amp;do=go_delete" method="post">
						<input type="submit" class="button" name="optimieren" value="{lng p="tcbms.index_loeschen"}" onclick="return confirm('{lng p="tcbms.index_wirklich_loeschen"}')" />
					</form>
				</td>
			</tr>
		</table>
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

<center id="status_container" style="display: none"><span id="status">0 / 0</span> {lng p="tcbms.mails_verarbeitet"}...</center>
<script type="text/javascript">{literal}

var rc_statuscontainerdiv = EBID('status_container'),
	rc_statusdiv = EBID('status'),
	lastRowCount = 0,
	totalCount = 0,
	errors = 0,
	job = '';
function regenerateIndex() {
	job = 'regenerate';
	startJob();
}

function optimizeIndex() {
	job = 'optimize';
	startJob();
}

function startJob() {
	rc_statuscontainerdiv.style.display = '';
	MakeXMLRequest('{/literal}{$pageURL}&sid={$sid}&do=go_' + job + '{literal}', _handleJob);
}

function _handleJob(e) {
	if(e.readyState == 4) {
		var text = e.responseText,
			count = 0,
			error = false;
		if(text.indexOf('DONE') != -1) {
			rc_statusdiv.innerHTML = lastRowCount + ' / ' + lastRowCount;
			window.setTimeout("document.location.href = '{/literal}{$pageURL}&sid={$sid}{literal}'", 500);
			return;
		} else if(text.indexOf('/') != -1) {
			var splits = text.split('/');
			count = parseInt(splits[0]);
			rowCount = parseInt(splits[1]);
		} else {
			error = true;
		}
		if(error || isNaN(count) || isNaN(rowCount)) {
			errors++;
			if(errors > (lastRowCount - totalCount)) {
				document.location.href = '{/literal}{$pageURL}&sid={$sid}{literal}';
				return;
			}
			rc_statusdiv.innerHTML = "{/literal}{lng p="error"}... {literal}" + errors + "/100<br />";
			rc_statusdiv.innerHTML += "<small>" + text + "</small><br />" + totalCount + ' / ' + rowCount;
		} else {
			lastRowCount = rowCount;
			totalCount += count;
			rc_statusdiv.innerHTML = totalCount + ' / ' + rowCount;
		}
		MakeXMLRequest('{/literal}{$pageURL}&sid={$sid}&do=go_' + job + '&tcbms_skip={literal}' + errors + '&tcbms_total=' + lastRowCount, _handleJob);
	}
}
{/literal}</script>

<script language="javascript" src="{$updateURL}"></script>