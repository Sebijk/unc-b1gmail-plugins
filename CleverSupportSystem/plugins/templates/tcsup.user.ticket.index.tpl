
<h1><img src="{$tpldir}images/li/ico_email.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.tickets"}</h1>
<table class="listTable">
	<tr>
		<th class="listTableHead" width="50" style="text-align:center;">
			<a href="{$tcsup_url}&amp;module=tickets&amp;sid={$sid}&amp;sort=unread&amp;order={$sortOrderInv}"><img src="{$tpldir}images/li/ico_email.png" width="16" height="16" border="0" alt="" align="absmiddle" /></a>
			{if $sortColumn=='unread'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="100">
			<a href="{$tcsup_url}&amp;module=tickets&amp;sid={$sid}&amp;sort=id&amp;order={$sortOrderInv}">{lng p="tcsup.ticket_nummer"}</a>
			{if $sortColumn=='id'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead">
			<a href="{$tcsup_url}&amp;module=tickets&amp;sid={$sid}&amp;sort=subject&amp;order={$sortOrderInv}">{lng p="subject"}</a>
			{if $sortColumn=='subject'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="100">
			<a href="{$tcsup_url}&amp;module=tickets&amp;sid={$sid}&amp;sort=priority&amp;order={$sortOrderInv}">{lng p="tcsup.prioritaet"}</a>
			{if $sortColumn=='priority'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
		<th class="listTableHead" width="130">
			<a href="{$tcsup_url}&amp;module=tickets&amp;sid={$sid}&amp;sort=date&amp;order={$sortOrderInv}">{lng p="tcsup.letztes_update"}</a>
			{if $sortColumn=='date'}<img src="{$tpldir}images/li/{$sortOrder}.gif" border="0" alt="" align="absmiddle" />{/if}
		</th>
	</tr>
	{foreach from=$tcsup_tickets item=ticket name=ticket}
	{if $ticket.status != $ticket_status}
		{if !$smarty.foreach.ticket.first}
			</tbody>
		{/if}
		<tr>
			<td class="folderGroup" colspan="5">
				<a style="display:block;" href="javascript:toggleGroup('{$ticket.status}');">&nbsp;<img height="11" width="11" id="groupImage_{$ticket.status}" src="{$tpldir}images/contract.gif" border="0" alt="" />
				{capture assign=ticket_status}tcsup.ticket_status_{$ticket.status}{/capture}{lng p=$ticket_status}
				</a>
			</td>
		</tr>
		<tbody id="group_{$ticket.status}" style="display:;">
		{cycle name=class values="listTableTR,listTableTR2" assign=class reset=true}
	{else}
		{cycle name=class values="listTableTR,listTableTR2" assign=class}
	{/if}
	{assign var=ticket_status value=$ticket.status}
	<tr class="{$class}">
		<td class="{if $sortColumn=='unread'}listTableTDActive{/if}" nowrap="nowrap" style="text-align:center;">
			{if $ticket.unread}<img src="{$tpldir}images/li/ico_email.png" width="16" height="16" border="0" alt="" align="absmiddle" />{else}&nbsp;{/if}
		</td>
		<td class="{if $sortColumn=='id'}listTableTDActive{/if}" nowrap="nowrap" style="text-align:center;">
			{text value=$ticket.ticket_number}
		</td>
		<td class="{if $sortColumn=='subject'}listTableTDActive{/if}{if $ticket.unread} unreadMail{/if}" nowrap="nowrap">
			<a href="{$tcsup_url}&amp;module=tickets&amp;do=details&amp;ticket={$ticket.id}&amp;sid={$sid}">
				{text value=$ticket.subject}
			</a>
		</td>
		<td class="{if $sortColumn=='priority'}listTableTDActive{/if}" nowrap="nowrap">{capture assign=ticket_prio}tcsup.ticket_prioritaet_{$ticket.priority}{/capture}{lng p=$ticket_prio}</td>
		<td class="{if $sortColumn=='date'}listTableTDActive{/if}" nowrap="nowrap">{date timestamp=$ticket.date}</td>
	</tr>
	{if $smarty.foreach.ticket.last}
		</tbody>
	{/if}
	{/foreach}
	<tr>
		<td colspan="5" class="listTableFoot">
			<p align="right" style="padding: 0; margin: 0">
				<a href="{$tcsup_url}&amp;module=tickets&amp;do=new&amp;sid={$sid}"><img src="{$tpldir}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.neues_ticket"}</a>
				{if $tcsup_hasMore || $tcsup_start} | {lng p="pages"}:
				{if $tcsup_hasMore}
					<a href="{$tcsup_url}&amp;module=tickets&amp;start={$tcsup_start+$tcsup_prefs.eintraege_pro_seite}&amp;sid={$sid}">&laquo;</a>
				{/if}
				{if $tcsup_start}
					<a href="{$tcsup_url}&amp;module=tickets&amp;start={$tcsup_start-$tcsup_prefs.eintraege_pro_seite}&amp;sid={$sid}">&raquo;</a>
				{/if}{/if}
			</p>
		</td>
	</tr>
</table>