<form action="{$pageURL}&amp;sid={$sid}&amp;action=settings&amp;do=save" method="post" onsubmit="spin(this)">
	<fieldset>
		<legend>{lng p="common"}</legend>
		<table>
			<tr>
				<td class="td1" width="200"><label for="knowledgebase_aktiviert">{lng p="tcsup.knowledgebase"}?</label></td>
				<td class="td2">
					<input id="knowledgebase_aktiviert" name="knowledgebase_aktiviert"{if $tcsup_prefs.knowledgebase_aktiviert} checked="checked"{/if} type="checkbox" value="1" />
				</td>
			</tr>
			<tr>
				<td class="td1"><label for="tickets_aktiviert">{lng p="tcsup.tickets"}?</label></td>
				<td class="td2">
					<input id="tickets_aktiviert" name="tickets_aktiviert"{if $tcsup_prefs.tickets_aktiviert} checked="checked"{/if} type="checkbox" value="1" />
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset>
		<legend>{lng p="tcsup.tickets"}</legend>
		
		<table>
			<tr>
				<td class="td1" width="200"><label for="admin_benachrichtigen">{lng p="tcsup.admin_benachrichtigen"}?</label></td>
				<td class="td2">
					<input id="admin_benachrichtigen" name="admin_benachrichtigen"{if $tcsup_prefs.admin_benachrichtigen} checked="checked"{/if} type="checkbox" value="1" />
					<label for="admin_benachrichtigen_an"> {lng p="to2"}: </label>
					<input type="text" name="admin_benachrichtigen_an" id="admin_benachrichtigen_an" value="{text value=$tcsup_prefs.admin_benachrichtigen_an allowEmpty=true}" size="24" />
				</td>
			</tr>
			<tr>
				<td class="td1"><label for="user_benachrichtigen">{lng p="tcsup.user_benachrichtigen"}?</label></td>
				<td class="td2">
					<input id="user_benachrichtigen" name="user_benachrichtigen"{if $tcsup_prefs.user_benachrichtigen} checked="checked"{/if} type="checkbox" value="1" />
					<label for="user_benachrichtigen_von"> {lng p="tcsup.mail_absender"}: </label>
					<input type="text" name="user_benachrichtigen_von" id="user_benachrichtigen_von" value="{text value=$tcsup_prefs.user_benachrichtigen_von allowEmpty=true}" size="24" />
				</td>
			</tr>
			<tr>
				<td class="td1"><label for="ticket_nummer">{lng p="tcsup.ticket_nummer_format"}:</label></td>
				<td class="td2">
					<input type="text" name="ticket_nummer" id="ticket_nummer" value="{text value=$tcsup_prefs.ticket_nummer allowEmpty=true}" size="24" />
				</td>
			</tr>
		</table>
	</fieldset>
	<div style="float:right;">
		<input type="submit" class="button" value=" {lng p="save"} " />&nbsp;
	</div>
</form>