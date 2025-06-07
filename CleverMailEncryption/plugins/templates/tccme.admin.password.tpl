<fieldset>
	<legend>{lng p="tccme.warnung"}</legend>
	
	<table>
		<tr>
			<td width="36" valign="top"><img src="./templates/images/warning32.png" border="0" alt="" width="32" height="32" /></td>
			<td valign="top">
				{lng p="tccme.passwort_aendern"}
				<br />
				<form action="{$smarty.server.REQUEST_URI|escape:'html'}" method="post">
					{foreach from=$smarty.post item=pValue key=pKey}
					<input type="hidden" name="{$pKey|escape}" value="{$pValue|escape}" />
					{/foreach}
					<input type="checkbox" value="1" name="__tccme_deletion_confirmed" id="__tccme_deletion_confirmed" onclick="if(this.checked) return confirm('{lng p="tccme.passwort_aendern_bestaetigen"}');" /> <label for="__tccme_deletion_confirmed">{lng p="tccme.passwort_aendern_bestaetigen"}</label>
					<input type="submit" class="button" value="{lng p="next"}" />
				</form>
			</td>
		</tr>
	</table>
	<p align="right">
		<input type="button" class="button" onclick="history.back(1);" value=" {lng p="back"} " />
	</p>
</fieldset>