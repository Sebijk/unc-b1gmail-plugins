
<h1><img src="{$tpldir}images/li/ico_faq.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.knowledgebase"}</h1>

<small>{lng p="tcsup.breadcrumb"}: {include file=$tcsup_pageBreadcrumb}</small>
<br /><br />
{if !empty($tcsup_categoryOverview)}
<table class="listTable">
	<tr>
		<th class="listTableHead">{lng p="tcsup.in_kategorien"}</th>
	</tr>
	<tr>
		<td class="listTableRight">
		<table width="100%">
			{assign var=cols value=3}
			{math equation="x/y" x=100 y=$cols format="%.2F" assign=colspace}
			{foreach from=$tcsup_categoryOverview item=category name=category}
			{if $smarty.foreach.category.iteration % $cols == 1}<tr>{/if}
			<td width="{$colspace}%">
				<img src="{$tpldir}images/li/webdisk_folder.png" width="16" height="16" border="0" alt="" align="absmiddle" />
				<a href="{$tcsup_url}&amp;category={$category.id}&amp;sid={$sid}">{text value=$category.name}</a> ({$category.count})
				<br />
				<small>{text value=$category.description allowEmpty=true}</small>
			</td>
			{if $smarty.foreach.category.last && $smarty.foreach.category.iteration % $cols != 0}
				{section name=foo start=1 loop=$smarty.foreach.category.iteration%$cols step=1}
				<td width="{$colspace}%">&nbsp;</td>
				{/section}
			{/if}
			{if $smarty.foreach.category.iteration % $cols == 0 || $smarty.foreach.category.last}</tr>{/if}
			{/foreach}
		</table>
		</td>
	</tr>
</table>
<br />
{/if}
{if !isset($tcsup_popular)}
<table class="listTable">
	<tr>
		<th class="listTableHead">{lng p="tcsup.kategorie"}: {text value=$tcsup_categoryDetails.name}</th>
	</tr>
	<tr>
		<td class="listTableRight">
			<i>{text value=$tcsup_categoryDetails.description}</i><br />
			In dieser Kategorie wurden <b>{$tcsup_articles|@count}</b> Fragen gefunden:<br />
			<hr size="1" color="#ddd" />
			<ol>
			{foreach from=$tcsup_articles item=article}
				<li>
					<a href="{$tcsup_url}&amp;article={$article.id}&amp;sid={$sid}">
						<img src="{$tpldir}images/li/ico_ok.png" width="16" height="16" border="0" alt="" align="absmiddle" />&nbsp;{text value=$article.title}
					</a>
					<br />
					<span class="description">{text value=$article.short_body allowEmpty=true}</span>
				</li>
			{/foreach}
			</ol>
		</td>
	</tr>
</table>
<br />
{/if}
{if !empty($tcsup_popular)}
<table width="100%" cellpadding="5">
	<tr>
		<td width="50%" valign="top">
			<table class="listTable">
				<tr>
					<th class="listTableHead">{lng p="tcsup.beliebteste_eintraege"}</th>
				</tr>
				<tr>
					<td class="listTableRight">
					<ol>
					{foreach from=$tcsup_popular item=article}
						<li>
							<a href="{$tcsup_url}&amp;article={$article.id}&amp;sid={$sid}">
								<img src="{$tpldir}images/li/ico_ok.png" width="16" height="16" border="0" alt="" align="absmiddle" />&nbsp;{text value=$article.title}
							</a>
						</li>
					{/foreach}
					</ol>
					</td>
				</tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<table class="listTable">
				<tr>
					<th class="listTableHead">{lng p="tcsup.neuste_eintraege"}</th>
				</tr>
				<tr>
					<td class="listTableRight">
					<ol>
					{foreach from=$tcsup_new item=article}
						<li>
							<a href="{$tcsup_url}&amp;article={$article.id}&amp;sid={$sid}">
								<img src="{$tpldir}images/li/ico_ok.png" width="16" height="16" border="0" alt="" align="absmiddle" />&nbsp;{text value=$article.title}
							</a>
						</li>
					{/foreach}
					</ol>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
{/if}