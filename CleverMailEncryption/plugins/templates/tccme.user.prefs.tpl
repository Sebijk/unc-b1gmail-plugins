<h1><img src="plugins/templates/images/tccme_icon16.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tccme_mod2"}</h1>
{lng p="prefs_d_tccme_mod"}
<br /><br />
<table class="listTable">
	<tr>
		<th class="listTableHead" colspan="2"> {lng p="tccme_mod2"}</th>
	</tr>
	<tr>
		<td class="listTableLeft">{lng p="tccme.status"}:</td>
		<td class="listTableRight">
			{if !$tccme_hasKey}
				<img src="{$tpldir}images/li/mailico_encrypted_error.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tccme.status_key_fehlt"}
			{elseif $tccme_mailCountPercent == 100}
				<img src="{$tpldir}images/li/yes.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tccme.status_fertig"}
			{else}
				<img src="{$tpldir}images/load_16.gif" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tccme.status_laeuft"}
			{/if}
		</td>
	</tr>
	<tr>
		<td class="listTableLeft">{lng p="tccme.verschluesselte_mails"}:</td>
		<td class="listTableRight">
			{$tccme_mailCount} ({if $tccme_mailCountPercent == 100}<strong>{$tccme_mailCountPercent}%</strong>{else}{$tccme_mailCountPercent}%{/if})
		</td>
	</tr>
	<tr>
		<td class="listTableLeft">{lng p="tccme.private_key"}:</td>
		<td class="listTableRight">
			{lng p="tccme.backup_hinweis"}<br /><br />
			<form action="{$smarty.server.REQUEST_URI|escape:'html'}" method="post">
				<input type="submit" value="{lng p='tccme.backup_herunterladen'}" name="tccme_backup"{if !$tccme_hasKey} disabled="disabled"{/if} />
			</form>
		</td>
	</tr>
</table>
{if $tccme_mailCountPercent != 100}
<script type="text/javascript">
setTimeout('window.location.reload()',30000)
</script>
{/if}