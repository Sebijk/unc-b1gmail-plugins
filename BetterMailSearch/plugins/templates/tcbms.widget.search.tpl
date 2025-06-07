<div class="innerWidget" style="text-align:center;">
	<form action="start.php?action=tcbms_search&sid={$sid}&sort={$sortColumn}&order={$sortOrder}" method="post" onsubmit="document.location.href = this.action + '&js=1&q=' + (encodeURIComponent(EBID('tcbms_search_q').value)); return false;">
		<table cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td><input id="tcbms_search_q" type="text" name="q" value="" style="width:100%;" /></td>
				<td width="80" align="right"><input type="submit" value=" {lng p="tcbms.suchen"} " /></td>
			</tr>
		</table>
	</form>
</div>