<h1><img src="plugins/templates/images/tccme_icon16.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tccme_mod2"}</h1>
{lng p="tccme.key_nicht_geladen"}
<br /><br />
<table class="listTable">
	<tr>
		<th class="listTableHead" colspan="2"> {lng p="tccme_mod2"}</th>
	</tr>
	<tr>
		<td class="listTableLeft">{lng p="tccme.backup_hochladen"}:</td>
		<td class="listTableRight">
			<form action="{$smarty.server.REQUEST_URI|escape:'html'}" method="post" enctype="multipart/form-data">
				<input type="file" name="tccme_key" /><br /><input type="submit" value="{lng p='tccme.weiter'}" name="tccme_backup" />
			</form>
			<br />&nbsp;
		</td>
	</tr>
	<tr>
		<td class="listTableLeft">{lng p="tccme.neue_schluessel"}:</td>
		<td class="listTableRight">
			<form action="{$smarty.server.REQUEST_URI|escape:'html'}" method="post">
				{lng p="tccme.neue_schluessel_warnung"}<br />
				<input type="checkbox" value="1" name="tccme_deletion_confirmed" id="tccme_deletion_confirmed" onclick="if(this.checked) return confirm('{lng p="tccme.neue_schluessel_bestaetigen"}');" /> <label for="tccme_deletion_confirmed">{lng p="tccme.neue_schluessel_bestaetigen"}</label>
				<br />
				<input type="submit" value="{lng p='tccme.weiter'}" name="tccme_backup" />
			</form>
		</td>
	</tr>
</table>
{if $tccme_mailCountPercent != 100}
<script type="text/javascript">
setTimeout('window.location.reload()',30000)
</script>
{/if}