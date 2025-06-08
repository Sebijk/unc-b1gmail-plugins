<fieldset>
		<legend>{lng p="tcsup.tickets"}</legend>
		<table width="100%">
			<tr>
				<td class="td1" width="200">{lng p="tcsup.offene_tickets"}:</td>
				<td class="td2">{$tcsup_ticketsOpen}</td>
			</tr>
			<tr>
				<td class="td1" width="200">{lng p="tcsup.ungelesene_tickets"}:</td>
				<td class="td2">{$tcsup_ticketsUnread}</td>
			</tr>
		</table>
</fieldset>
<fieldset>
		<legend>{lng p="tcsup.knowledgebase"}</legend>
		<table width="100%">
			<tr>
				<td class="td1" width="200">{lng p="tcsup.kategorien"}:</td>
				<td class="td2">{$tcsup_kbCategories}</td>
			</tr>
			<tr>
				<td class="td1" width="200">{lng p="tcsup.artikel"}:</td>
				<td class="td2">{$tcsup_kbArticles}</td>
			</tr>
			<tr>
				<td class="td1" width="200">
					<a href="{$pageURL}&amp;action=knowledgebase&amp;do=showRatings&amp;sid={$sid}">
						{lng p="tcsup.bewertungen"}:
					</a>
				</td>
				<td class="td2">{$tcsup_kbRatings} ({lng p="tcsup.hilfreich"}: {$tcsup_kbRatingsPositive}, {lng p="tcsup.nicht_hilfreich"}: {$tcsup_kbRatings-$tcsup_kbRatingsPositive})</td>
			</tr>
		</table>
</fieldset>
<fieldset>
	<legend>{lng p="notices"}</legend>
	
	<table width="100%" id="noticeTable">
	{foreach from=$notices item=notice}
		<tr>
			<td width="20" valign="top"><img src="{$tpldir}images/{$notice.type}.png" width="16" height="16" border="0" alt="" align="absmiddle" /></td>
			<td valign="top">{$notice.text}</td>
			<td align="right" valign="top" width="20">{if $notice.link}<a href="{$notice.link}sid={$sid}"><img src="{$tpldir}images/go.png" border="0" alt="" width="16" height="16" /></a>{else}&nbsp;{/if}</td>
		</tr>
	{/foreach}
	</table>
</fieldset>

<!--<script language="javascript" src="{$updateURL}"></script>-->
