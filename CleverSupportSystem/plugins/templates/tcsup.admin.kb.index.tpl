<script type="text/javascript">

function singleAction2(action, id)
{ldelim}
	EBID('singleAction2').value = action;
	EBID('singleID2').value = id;
	spin(document.forms.f2);
	document.forms.f2.submit();
{rdelim}

function toggleGroup(id)
{ldelim}
	var groupItem = EBID('group_' + id);
	var groupItemImg = EBID('groupImage_' + id);
	
	if(groupItem.style.display == '')
	{ldelim}
		groupItem.style.display = 'none';
		groupItemImg.src = groupItemImg.src.replace(/contract/, 'expand');
		{rdelim}
	else
	{ldelim}
		groupItem.style.display = '';
		groupItemImg.src = groupItemImg.src.replace(/expand/, 'contract');
	{rdelim}
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
<small>{lng p="tcsup.breadcrumb"}: {include file=$tcsup_pageBreadcrumb}</small>
<form method="post" name="f1" action="{$pageURL}&amp;action=knowledgebase&amp;do=categoryAction&amp;id={$tcsup_categoryDetails.id}&amp;sid={$sid}">
	<input type="hidden" name="singleAction" id="singleAction" value="" />
	<input type="hidden" name="singleID" id="singleID" value="" />
	<fieldset>
		<legend>{lng p="tcsup.in_kategorien"}</legend>
		<table class="list">
			<tr>
				<th width="20">&nbsp;</th>
				<th width="25" style="text-align:center;"><a href="javascript:invertSelection(document.forms.f1,'category');"><img src="{$tpldir}images/dot.png" border="0" alt="" width="10" height="8" /></a></th>
				<th>{lng p="tcsup.kategorie"}
					<img src="{$tpldir}images/sort_{$sortOrder}.png" border="0" alt="" width="7" height="6" align="absmiddle" /></th>
				<th width="150">{lng p="tcsup.anzahl_artikel"}</th>
				<th width="55">&nbsp;</th>
			</tr>
			{foreach from=$tcsup_categoryOverview item=category name=category}
			{if empty($tcsup_activeCategory) && $category.language != $lastLanguage}
				{if !$smarty.foreach.category.first}
					</tbody>
				{/if}
				<tr>
					<td class="folderGroup" colspan="5">
						<a style="display:block;" href="javascript:toggleGroup('{$category.language}');">&nbsp;<img height="11" width="11" id="groupImage_{$category.language}" src="{$tpldir}images/contract.gif" border="0" alt="" />
						{text value=$languages[$category.language].title}
						</a>
					</td>
				</tr>
				<tbody id="group_{$category.language}" style="display:;">
				{cycle name=class values="td1,td2" assign=class reset=true}
			{else}
				{cycle name=class values="td1,td2" assign=class}
			{/if}
			{assign var=lastLanguage value=$category.language}
			<tr class="{$class}">
				<td>
					<img src="{$tpldir_user}images/li/webdisk_folder.png" width="16" height="16" border="0" alt="" align="absmiddle" />
				</td>
				<td align="center"><input type="checkbox" name="category[]" value="{$category.id}" /></td>
				<td>
					<a href="{$pageURL}&amp;action=knowledgebase&amp;category={$category.id}&amp;sid={$sid}">
						{text value=$category.name}
					</a>
				</td>
				<td>{$category.count}</td>
				{*<td>{text value=$languages[$category.language].title}</td>*}
				<td>
					<a href="{$pageURL}&amp;action=knowledgebase&amp;do=editCategory&amp;id={$category.id}&amp;sid={$sid}" title="{lng p="edit"}"><img src="{$tpldir}images/edit.png" border="0" alt="{lng p="edit"}" width="16" height="16" /></a>
					<a href="javascript:singleAction('delete', '{$category.id}');" onclick="return confirm('{lng p="realdel"}');" title="{lng p="delete"}"><img src="{$tpldir}images/delete.png" border="0" alt="{lng p="delete"}" width="16" height="16" /></a>
				</td>
			</tr>
			{if empty($tcsup_activeCategory) && $smarty.foreach.category.last}
				</tbody>
			{/if}
			{/foreach}
		
			<tr>
				<td class="footer" colspan="5">
					<div style="float:left;">
						{lng p="action"}: <select name="massAction" class="smallInput">
							<option value="-">------------</option>
							
							<optgroup label="{lng p="actions"}">
								<option value="delete">{lng p="delete"}</option>
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
						<a href="{$pageURL}&amp;action=knowledgebase&amp;do=addCategory&amp;id={$tcsup_categoryDetails.id}&amp;sid={$sid}"><img src="{$tpldir_user}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.kategorie_hinzufuegen"}</a>
					</div>
				</td>
			</tr>
		</table>
	</fieldset>
</form>

{if isset($tcsup_articles)}
<form method="post" name="f2" action="{$pageURL}&amp;action=knowledgebase&amp;do=articleAction&amp;id={$tcsup_categoryDetails.id}&amp;sid={$sid}">
	<input type="hidden" name="singleAction" id="singleAction2" value="" />
	<input type="hidden" name="singleID" id="singleID2" value="" />
	<fieldset>
		<legend>{lng p="tcsup.kategorie"}: {text value=$tcsup_categoryDetails.name}</legend>
		<table class="list">
			<tr>
				<th width="20">&nbsp;</th>
				<th width="25" style="text-align:center;"><a href="javascript:invertSelection(document.forms.f2,'article');"><img src="{$tpldir}images/dot.png" border="0" alt="" width="10" height="8" /></a></th>
				<th>{lng p="tcsup.artikel"}
					<img src="{$tpldir}images/sort_asc.png" border="0" alt="" width="7" height="6" align="absmiddle" /></th>
				<th width="75" style="text-align: center"><img src="{$tpldir}images/ok.png" border="0" alt="" width="14" height="14" align="absmiddle" alt="{lng p='tcsup.hilfreich'}" title="{lng p='tcsup.hilfreich'}" /></th>
				<th width="75" style="text-align: center"><img src="{$tpldir}images/delete.png" border="0" alt="" width="14" height="14" align="absmiddle" alt="{lng p='tcsup.nicht_hilfreich'}" title="{lng p='tcsup.nicht_hilfreich'}" /></th>
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
						{text value=$article.title}
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
					<a href="javascript:singleAction2('delete', '{$article.id}');" onclick="return confirm('{lng p="realdel"}');" title="{lng p="delete"}"><img src="{$tpldir}images/delete.png" border="0" alt="{lng p="delete"}" width="16" height="16" /></a>
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
						<input type="submit" class="button" name="executeMassAction" value=" {lng p="execute"} " class="smallInput" />
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
{/if}