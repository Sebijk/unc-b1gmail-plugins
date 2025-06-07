{if !$tctz_groupCount}
<fieldset>
	<legend>{lng p="tctz.warnung"}</legend>
	<table>
		<tr>
			<td align="left" valign="top" width="40"><img src="./templates/images/warning32.png" border="0" alt="" width="32" height="32" /></td>
			<td>
				<b>{lng p="tctz.keine_gruppe_aktiviert"}</b>
			</td>
		</tr>
	</table>
</fieldset>
{/if}
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

<script language="javascript" src="{$updateURL}"></script>