<script type="text/javascript">
function toggleGroup(id)
{ldelim}
	var groupItem = EBID('group_' + id);
	var groupItemImg = EBID('groupImage_' + id);

	var state = 'hidden';
	if(groupItem.style.display == '')
	{ldelim}
		groupItem.style.display = 'none';
		groupItemImg.src = groupItemImg.src.replace(/contract/, 'expand');
		{rdelim}
	else
	{ldelim}
		state = 'visible';
		groupItem.style.display = '';
		groupItemImg.src = groupItemImg.src.replace(/expand/, 'contract');
	{rdelim}
	MakeXMLRequest('{$pageURL}&action=tickets&do=toggleGroup&group=' + id + '&state=' + state + '&sid={$sid}');
{rdelim}
</script>
<style type="text/css">
.folderGroup
{ldelim}
	border-top: 1px solid #DDDDDD;
	border-bottom: 1px solid #CCCCCC;
	background-color: #F2F2F2;
{rdelim}

.folderGroup a:hover
{ldelim}
	text-decoration: none;
	color: #999999;
{rdelim}
</style>
<form method="post" name="f1" action="{$pageURL}&amp;action=tickets&amp;do=massAction&amp;sid={$sid}">
	<input type="hidden" name="singleAction" id="singleAction" value="" />
	<input type="hidden" name="singleID" id="singleID" value="" />
	<input type="hidden" name="sort" id="sortBy" value="{$sortColumn}" />
	<input type="hidden" name="order" id="sortOrder" value="{$sortOrder}" />
	<fieldset>
		<legend>{lng p="tcsup.tickets"}</legend>
		<table class="list">
			<tr>
				<th width="30" style="text-align:center;">
					<a href="javascript:updateSort('unread');">
						<img src="{$tpldir}images/ico_prefs_email.png" width="16" height="16" border="0" alt="" align="absmiddle" />
						{if $sortColumn=='unread'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="25" style="text-align:center;">
					<a href="javascript:invertSelection(document.forms.f1,'ticket');"><img src="{$tpldir}images/dot.png" border="0" alt="" width="10" height="8" /></a>
				</th>
				<th width="100">
					<a href="javascript:updateSort('id');">{lng p="tcsup.ticket_nummer"}
						{if $sortColumn=='id'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th>
					<a href="javascript:updateSort('subject');">{lng p="subject"}
						{if $sortColumn=='subject'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="100">
					<a href="javascript:updateSort('priority');">{lng p="tcsup.prioritaet"}
						{if $sortColumn=='priority'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="150">
					<a href="javascript:updateSort('date');">{lng p="tcsup.letztes_update"}
						{if $sortColumn=='date'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="55">&nbsp;</th>
			</tr>
			{foreach from=$tcsup_tickets item=ticket name=ticket}
			{if $ticket.status != $ticket_status}
				{if !$smarty.foreach.ticket.first}
					</tbody>
				{/if}
				<tr>
					<td class="folderGroup" colspan="7">
						<a style="display:block;" href="javascript:toggleGroup('{$ticket.status}');">&nbsp;<img height="11" width="11" id="groupImage_{$ticket.status}" src="{$tpldir}images/contract.png" border="0" alt="" />
						{capture assign=ticket_status}tcsup.ticket_status_{$ticket.status}{/capture}{lng p=$ticket_status}
						</a>
					</td>
				</tr>
				<tbody id="group_{$ticket.status}" style="display:;">
				{if $smarty.session.tcsup[$ticket.status] == 'hidden'}
					<script type="text/javascript">toggleGroup('{$ticket.status}');</script>
				{/if}
				{cycle name=class values="td1,td2" assign=class reset=true}
			{else}
				{cycle name=class values="td1,td2" assign=class}
			{/if}
			{assign var=ticket_status value=$ticket.status}
			<tr class="{$class}">
				<td style="text-align:center;">
					{if $ticket.unread}<img src="{$tpldir}images/ico_prefs_email.png" width="16" height="16" border="0" alt="" align="absmiddle" />{else}&nbsp;{/if}
				</td>
				<td align="center"><input type="checkbox" name="ticket[]" value="{$ticket.id}" /></td>
				<td>{text value=$ticket.ticket_number}</td>
				<td{if $ticket.unread} style="font-weight: bold;"{/if}>
					<a href="{$pageURL}&amp;action=tickets&amp;do=details&amp;ticket={$ticket.id}&amp;sid={$sid}">
						{text value=$ticket.subject}
					</a>
				</td>
				<td>{capture assign=ticket_prio}tcsup.ticket_prioritaet_{$ticket.priority}{/capture}{lng p=$ticket_prio}</td>
				<td>{date timestamp=$ticket.date}</td>
				<td>
					<a href="{$pageURL}&amp;action=tickets&amp;do=details&amp;ticket={$ticket.id}&amp;sid={$sid}"><img src="{$tpldir}images/go.png" border="0" alt="{lng p="edit"}" width="16" height="16" /></a>
					<a href="javascript:singleAction('delete', '{$ticket.id}');" onclick="return confirm('{lng p="realdel"}');" title="{lng p="delete"}"><img src="{$tpldir}images/delete.png" border="0" alt="{lng p="delete"}" width="16" height="16" /></a>
				</td>
			</tr>
			{if $smarty.foreach.ticket.last}
				</tbody>
			{/if}
			{/foreach}
		
			<tr>
				<td class="footer" colspan="7">
					<div style="float:left;">
						{lng p="action"}: <select name="massAction" class="smallInput">
							<option value="-">------------</option>
							
							<optgroup label="{lng p="tcsup.status_setzen"}">
								<option value="01offen">{lng p="tcsup.ticket_status_01offen"}</option>
								<option value="02zugewiesen">{lng p="tcsup.ticket_status_02zugewiesen"}</option>
								<option value="03bearbeitung">{lng p="tcsup.ticket_status_03bearbeitung"}</option>
								<option value="04warten">{lng p="tcsup.ticket_status_04warten"}</option>
								<option value="05geschlossen">{lng p="tcsup.ticket_status_05geschlossen"}</option>
							</optgroup>
							
							<optgroup label="{lng p="tcsup.prioritaet_setzen"}">
								<option value="1">{lng p="tcsup.ticket_prioritaet_1"}</option>
								<option value="2">{lng p="tcsup.ticket_prioritaet_2"}</option>
								<option value="3">{lng p="tcsup.ticket_prioritaet_3"}</option>
							</optgroup>
							
							<optgroup label="{lng p="actions"}">
								<option value="delete">{lng p="delete"}</option>
								<option value="markread">{lng p="markread"}</option>
								<option value="markunread">{lng p="markunread"}</option>
							</optgroup>
						</select>&nbsp;
					</div>
					<div style="float:left;">
						<input type="submit" class="button smallInput" name="executeMassAction" value=" {lng p="execute"} " />
					</div>
					{if $tcsup_hasMore || $tcsup_start}
					<div style="float:right;padding-top:3px;">
						{lng p="pages"}:
						{if $tcsup_hasMore}
							<a href="{$pageURL}&amp;action=tickets&amp;start={$tcsup_start+$tcsup_prefs.eintraege_pro_seite}&amp;sid={$sid}">&laquo;</a>
						{/if}
						{if $tcsup_start}
							<a href="{$pageURL}&amp;action=tickets&amp;start={$tcsup_start-$tcsup_prefs.eintraege_pro_seite}&amp;sid={$sid}">&raquo;</a>
						{/if}
					</div>
					{/if}
				</td>
			</tr>
		</table>
	</fieldset>
</form>