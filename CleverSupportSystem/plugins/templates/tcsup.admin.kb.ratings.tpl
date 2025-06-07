<form method="post" name="f1" action="{$pageURL}&amp;action=knowledgebase&amp;do=showRatings&amp;sid={$sid}">
	<input type="hidden" name="singleAction" id="singleAction" value="" />
	<input type="hidden" name="singleID" id="singleID" value="" />
	<input type="hidden" name="sort" id="sortBy" value="{$sortColumn}" />
	<input type="hidden" name="order" id="sortOrder" value="{$sortOrder}" />
	<fieldset>
		<legend>{lng p="tcsup.bewertungen"}</legend>
		<table class="list">
			<tr>
				<th width="20">&nbsp;</th>
				<th width="25" style="text-align:center;"><a href="javascript:invertSelection(document.forms.f1,'article');"><img src="{$tpldir}images/dot.png" border="0" alt="" width="10" height="8" /></a></th>
				<th>
					<a href="javascript:updateSort('title');">
						{lng p="tcsup.artikel"}
						{if $sortColumn=='title'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="75" style="text-align: center">
					<a href="javascript:updateSort('positive');">
						<img src="{$tpldir}images/ok.png" border="0" alt="" width="14" height="14" align="absmiddle" alt="{lng p='tcsup.hilfreich'}" title="{lng p='tcsup.hilfreich'}" />
						{if $sortColumn=='positive'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="75" style="text-align: center">
					<a href="javascript:updateSort('negative');">
						<img src="{$tpldir}images/delete.png" border="0" alt="" width="14" height="14" align="absmiddle" alt="{lng p='tcsup.nicht_hilfreich'}" title="{lng p='tcsup.nicht_hilfreich'}" />
						{if $sortColumn=='negative'}<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" />{/if}
					</a>
				</th>
				<th width="55">&nbsp;</th>
			</tr>
			{foreach from=$tcsup_articles item=article}
			{cycle name=class values="td1,td2" assign=class}
			<tr class="{$class}">
				<td>
					<img src="{$tpldir_user}images/li/ico_ok.png" width="16" height="16" border="0" alt="" align="absmiddle" />
				</td>
				<td align="center"><input type="checkbox" name="article[]" value="{$article.id}" /></td>
				<td>
					<a href="{$pageURL}&amp;action=knowledgebase&amp;do=editArticle&amp;id={$article.id}&amp;sid={$sid}">
						{text value=$article.title} {$article.nulltest}
					</a>
				</td>
				<td style="text-align: right">
					{if $article.votes > 0}
						{$article.positive_num} ({$article.positive}%)
					{else}
						-
					{/if}
				</td>
				<td style="text-align: right">
					{if $article.votes > 0}
						{$article.negative_num} ({$article.negative}%)
					{else}
						-
					{/if}
				</td>
				<td>
					<a href="{$pageURL}&amp;action=knowledgebase&amp;do=editArticle&amp;id={$article.id}&amp;sid={$sid}" title="{lng p="edit"}"><img src="{$tpldir}images/edit.png" border="0" alt="{lng p="edit"}" width="16" height="16" /></a>
					<a href="javascript:singleAction('deleteRatings', '{$article.id}');" title="{lng p="tcsup.bewertungen_loeschen"}"><img src="{$tpldir}images/delete.png" border="0" alt="{lng p="tcsup.bewertungen_loeschen"}" width="16" height="16" /></a>
				</td>
			</tr>
			{/foreach}
		
			<tr>
				<td class="footer" colspan="6">
					<div style="float:left;">
						{lng p="action"}: <select name="massAction" class="smallInput">
							<option value="-">------------</option>
							
							<optgroup label="{lng p="actions"}">
								<option value="delete">{lng p="delete"}</option>
								<option value="deleteRatings">{lng p="tcsup.bewertungen_loeschen"}</option>
							</optgroup>
							
							<optgroup label="{lng p="move"}">
							{foreach from=$tcsup_categoryDropdown key=language item=category}
								<option value="{$language}">{text value=$languages[$language].title}</option>
								{tcsup_categoryOptions categories=$category ignore=$tcsup_activeCategory}
							{/foreach}
							</optgroup>
						</select>&nbsp;
					</div>
					<div style="float:left;">
						<input type="submit" class="button smallInput" name="executeMassAction" value=" {lng p="execute"} " />
					</div>
					<div style="float:right;padding-top:3px;">
						<a href="{$pageURL}&amp;action=knowledgebase&amp;do=importFaq&amp;id={$tcsup_categoryDetails.id}&amp;sid={$sid}" onclick="return confirm('{lng p='tcsup.faq_wirklich_importieren'}')"><img src="{$tpldir}images/go.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.faq_importieren"}</a>
						<a href="{$pageURL}&amp;action=knowledgebase&amp;do=addArticle&amp;id={$tcsup_categoryDetails.id}&amp;sid={$sid}"><img src="{$tpldir_user}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.artikel_hinzufuegen"}</a>
					</div>
				</td>
			</tr>
		</table>
	</fieldset>
</form>