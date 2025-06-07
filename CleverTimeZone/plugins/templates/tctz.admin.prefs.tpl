<form action="{$pageURL}&amp;sid={$sid}&amp;action=settings&amp;do=save" method="post" onsubmit="spin(this)">
	<fieldset>
		<legend>{lng p="tctz_google_key"}</legend>
		{lng p="tctz_google_key_instruction"}<br />
		<input type="text" name="google_key" id="google_key" value="{text value=$tctz_prefs.google_key allowEmpty=true}" size="60" style="width: 100%; max-width: 800px;" />
	</fieldset>
	{if $tctz_prefs.google_key}
	<fieldset>
		<legend>{lng p="tctz_default_timezone"}</legend>
		<table>
			<tr>
				<td class="td2" colspan="2">
					{lng p="tctz_instruction"}
				</td>
			</tr>
			<tr>
				<td class="td1" width="200">{lng p="tctz_map"}:</td>
				<td class="td2">
					<input type="text" name="address" id="address" size="40" onkeypress="return lookup(event);" /> <input type="button" class="button" onclick="lookup()" value="{lng p="tctz_search"}" /><br /><br />
					<div id="map_canvas" style="width: 600px; height: 300px">{lng p="tctz_google_loading"}</div>
				</td>
			</tr>
			<tr>
				<td class="td1"><label for="tctz_tz">{lng p="tctz_timezone"}:</label></td>
				<td class="td2">
					<input type="text" value="{text value=$tctz_prefs.timezone allowEmpty=true}" readonly="readonly" name="timezone" id="tctz_tz" size="24" />
				</td>
			</tr>
		</table>
	</fieldset>
	{/if}
	
	<div style="float:right;">
		<input type="submit" class="button" value=" {lng p="save"} " />&nbsp;
	</div>
	<input type="hidden" value="{text value=$tctz_coordinates allowEmpty=true}" name="coordinates" id="tctz_coord" />
</form>
<div style="clear: right">&nbsp;</div>
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
{assign var="tctz_coordinates" value="`$tctz_prefs.coordinates`"}
{include file="$tctz_include_javascript"}