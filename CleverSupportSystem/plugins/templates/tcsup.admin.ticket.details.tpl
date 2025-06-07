<form method="post" name="f1" action="{$pageURL}&amp;action=tickets&amp;do=saveDetails&amp;ticket={$tcsup_ticket.id}&amp;sid={$sid}" onsubmit="editor.submit();spin(this);">
	<fieldset>
			<legend>{lng p="tcsup.ticket_details"}</legend>
			<table width="100%">
				<tr>
					<td align="left" rowspan="5" valign="top" width="40"><img src="{$tpldir}/images/ico_email.png" border="0" alt="" width="32" height="32" /></td>
					<td class="td1" width="200">{lng p="tcsup.ticket_nummer"}:</td>
					<td class="td2">{text value=$tcsup_ticket.ticket_number}</td>
				</tr>
				<tr>
					<td class="td1" width="200">{lng p="subject"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="subject" value="{text value=$tcsup_ticket.subject}" /></td>
				</tr>
				<tr>
					<td class="td1" width="200">{lng p="tcsup.prioritaet"}:</td>
					<td class="td2">
						<select name="priority">
							<option value="1"{if $tcsup_ticket.priority == 1} selected="selected"{/if}>{lng p="tcsup.ticket_prioritaet_1"}</option>
							<option value="2"{if $tcsup_ticket.priority == 2} selected="selected"{/if}>{lng p="tcsup.ticket_prioritaet_2"}</option>
							<option value="3"{if $tcsup_ticket.priority == 3} selected="selected"{/if}>{lng p="tcsup.ticket_prioritaet_3"}</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td1" width="200">{lng p="tcsup.status"}:</td>
					<td class="td2">
						<select name="status">
							<option value="01offen"{if $tcsup_ticket.status == '01offen'} selected="selected"{/if}>{lng p="tcsup.ticket_status_01offen"}</option>
							<option value="02zugewiesen"{if $tcsup_ticket.status == '02zugewiesen'} selected="selected"{/if}>{lng p="tcsup.ticket_status_02zugewiesen"}</option>
							<option value="03bearbeitung"{if $tcsup_ticket.status == '03bearbeitung'} selected="selected"{/if}>{lng p="tcsup.ticket_status_03bearbeitung"}</option>
							<option value="04warten"{if $tcsup_ticket.status == '04warten'} selected="selected"{/if}>{lng p="tcsup.ticket_status_04warten"}</option>
							<option value="05geschlossen"{if $tcsup_ticket.status == '05geschlossen'} selected="selected"{/if}>{lng p="tcsup.ticket_status_05geschlossen"}</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td1" width="200">{lng p="user"}:</td>
					<td class="td2">
						<a href="users.php?do=edit&amp;id={$tcsup_ticket.user_id}&amp;sid={$sid}">{text value=$tcsup_user.nachname}, {text value=$tcsup_user.vorname}</a> | {text value=$tcsup_user.email}
					</td>
				</tr>
			</table>
			
			<p align="right">
				<input type="submit" class="button" value=" {lng p="save"} " />
			</p>
	</fieldset><br />
<a href="#addComment" onclick="editor.focus();">
	<img src="{$tpldir_user}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" />
	{lng p="tcsup.kommentar_hinzufuegen"}
</a>
<br />
{foreach from=$tcsup_ticket.contents key=cid item=content}
<fieldset>
	<legend>
		{if $content.admin}
      {if $content.admin == 1}
        {lng p="tcsup.ticket_von_admin"}
      {else}
        {lng p="tcsup.ticket_von_admin_name"} &quot;{$content.admin}&quot;
      {/if}
		{else}
			<a href="users.php?do=edit&amp;id={$tcsup_ticket.user_id}&amp;sid={$sid}">{lng p="tcsup.ticket_von_user"} ({text value=$tcsup_user.nachname}, {text value=$tcsup_user.vorname})</a>
		{/if} - {date timestamp=$content.date nice=true elapsed=true} 
		<a href="{$pageURL}&amp;action=tickets&amp;do=deleteComment&amp;comment={$content.id}&amp;sid={$sid}" onclick="return confirm('{lng p="realdel"}');" title="{lng p="delete"}">
			<img src="{$tpldir}/images/delete.png" border="0" alt="" width="16" height="16" align="absmiddle" />
		</a>
	</legend>
	{$content.content}
	{if !empty($tcsup_ticket.files[$content.id])}
		<br />
		<hr />
		{foreach from=$tcsup_ticket.files[$content.id] item=file}
			<a href="{$pageURL}&amp;action=tickets&amp;do=getFile&amp;file={text value=$file.id}&amp;sid={$sid}">
				<img src="{$tpldir_user}images/li/mailico_attachment.gif" alt="" align="absmiddle" /> {text value=$file.dateiname}</a>
			<a href="{$pageURL}&amp;action=tickets&amp;do=deleteFile&amp;file={text value=$file.id}&amp;sid={$sid}&amp;ticket={$tcsup_ticket.id}" onclick="return confirm('{lng p="realdel"}');" title="{lng p="delete"}">
				<img src="{$tpldir}/images/delete.png" border="0" alt="" width="16" height="16" align="absmiddle" />
			</a>
		{/foreach}
	{/if}
</fieldset>
{/foreach}
<br />

	<fieldset>
		<legend>{lng p="tcsup.kommentar_hinzufuegen"} <a name="addComment" style="font-size:0;">&nbsp;</a></legend>
		<table width="100%">
			<tr>
				<td style="border: 1px solid #DDDDDD;background-color:#FFFFFF;">
					<textarea name="content" id="content" class="plainTextArea" style="width:100%;height:320px;"></textarea>
					<script language="javascript" src="../clientlib/wysiwyg.js"></script>
					<script language="javascript">
					<!--
						var editor = new htmlEditor('content', '{$tpldir_user}/images/editor/');
						editor.init();
						registerLoadAction('editor.start()');
					//-->
					</script>
				</td>
			</tr>
		</table>
		<p align="right">
			<input type="submit" class="button" value=" {lng p="save"} " />
		</p>
	</fieldset>
</form>