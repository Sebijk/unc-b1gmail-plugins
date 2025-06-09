<div id="contentHeader">
	<div class="left">
		<i class="fa fa-lock" aria-hidden="true"></i>
		{lng p="tccme_mod2"}
	</div>
</div>
<div class="scrollContainer"><div class="pad">
{lng p="prefs_d_tccme_mod"}
<br /><br />
<table class="listTable">
	<tr>
		<th class="listTableHead" colspan="2"> {lng p="tccme_mod2"}</th>
	</tr>
	<tr>
		<td class="listTableLeft">{lng p="status"}:</td>
		<td class="listTableRight">
			{if empty($tccme_hasKey)}
				<i class="fa fa-unlock-alt" aria-hidden="true"></i> {lng p="tccme.status_key_fehlt"}
			{elseif $tccme_mailCountPercent == 100}
				<i class="fa fa-check-circle" aria-hidden="true"></i> {lng p="tccme.status_fertig"}
			{else}
				<i class="fa fa-spinner fa-pulse fa-fw"></i> {lng p="tccme.status_laeuft"}
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
</div></div>
{if $tccme_mailCountPercent != 100}
<script type="text/javascript">
setTimeout('window.location.reload()',30000)
</script>
{/if}