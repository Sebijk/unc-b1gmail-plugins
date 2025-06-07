<h1><img src="plugins/templates/images/tctz_icon16.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tctz_mod2"}</h1>
	{lng p="prefs_d_tctz_mod"}
<br /><br />
<noscript><b>{lng p="jswarning"}</b><br /><br /></noscript>
<form name="f1" id="tctz_form" method="post" action="{$smarty.server.REQUEST_URI|escape:'html'}">
	<table class="listTable">
		<tr>
			<th class="listTableHead" colspan="2"> {lng p="tctz_mod2"}</th>
		</tr>
		<tr>
			<td class="listTableLeft">
				<label for="id_automatisch">{lng p="tctz_automatic"}?</label>
			</td>
			<td class="listTableRight">
				<input type="checkbox" name="automatic" id="id_automatisch" {if $tctz_automatic}checked="checked" {/if}value="0" onclick="tctz_switchAuto();" />
					<label for="id_automatisch">{lng p="enable"}</label>
			</td>
		</tr>
		<tbody id="tctz_map"{if $tctz_automatic} style="display:none"{/if}>
			<tr>
				<td class="listTableLeft">&nbsp;</td>
				<td class="listTableRight">
					{lng p="tctz_instruction"}
				</td>
			</tr>
			<tr>
				<td class="listTableLeft">{lng p="tctz_map"}:</td>
				<td class="listTableRight">
					<input type="text" name="address" id="address"  size="40" onkeypress="return lookup(event);" style="width:350px;" /> <input type="button" onclick="lookup()" value="{lng p="tctz_search"}" />
					<br /><br />
					<div id="map_canvas" style="width: 600px; height: 300px">{lng p="tctz_google_loading"}</div>
				</td>
			</tr>
		</tbody>
		<tr>
			<td class="listTableLeft"><label for="tctz_tz">{lng p="tctz_timezone"}:</label></td>
			<td class="listTableRight">
				<input type="text" value="{text value=$tctz_timezone allowEmpty=true}" disabled="disabled" name="timezone" id="tctz_tz" style="width:350px;" />
			</td>
		</tr>
		<tr>
			<td class="listTableLeft">&nbsp;</td>
			<td class="listTableRight">
				<input type="submit" value="{lng p='ok'}" id="tctz_ok" disabled="disabled" />
			</td>
		</tr>
	</table>
	<input type="hidden" value="{text value=$tctz_coordinates allowEmpty=true}" name="coordinates" id="tctz_coord" />
</form>

{include file="$tctz_include_javascript"}