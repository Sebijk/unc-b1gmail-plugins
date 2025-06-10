{if $tcsup_prefs.knowledgebase_aktiviert}<div class="sidebarHeading"> &nbsp; {lng p="tcsup.knowledgebase"}</div>
<div class="contentMenuIcons">
	&nbsp;<a href="{$tcsup_url}&amp;sid={$sid}"><i class="fa fa-tachometer" aria-hidden="true" style="width: 20px;"></i> {lng p="overview"}</a><br />
	{foreach from=$tcsup_categories item=category}
	&nbsp;<a href="{$tcsup_url}&amp;category={$category.id}&amp;sid={$sid}" title="{text value=$category.description}"><img src="{$tpldir}images/li/webdisk_folder.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {text value=$category.name}</a> ({$category.count})<br />
	{/foreach}
</div>
<br />{/if}

{if $tcsup_prefs.tickets_aktiviert}<div class="sidebarHeading"> &nbsp; {lng p="tcsup.tickets"}</div>
<div class="contentMenuIcons">
	&nbsp;<a href="{$tcsup_url}&amp;module=tickets&amp;sid={$sid}"><i class="fa fa-tachometer" aria-hidden="true" style="width: 20px;"></i> {lng p="overview"}{if $tcsup_ticketsUnread > 0} <b>({$tcsup_ticketsUnread})</b>{/if}</a><br />
	&nbsp;<a href="{$tcsup_url}&amp;module=tickets&amp;do=new&amp;sid={$sid}"><i class="fa fa-plus-circle" aria-hidden="true" style="width: 20px;"></i> {lng p="tcsup.neues_ticket"}</a><br />
</div>
{/if}