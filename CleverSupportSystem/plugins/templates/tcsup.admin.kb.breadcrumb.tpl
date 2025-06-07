<a href="{$pageURL}&amp;action=knowledgebase&amp;sid={$sid}">{lng p="tcsup.knowledgebase"}</a>
{foreach from=$tcsup_breadcrumb item=category name=category}
{if $tcsup_categoryActive == $category.id}
<b> &gt; {text value=$category.name}</b>
{else}
 &gt; <a href="{$pageURL}&amp;action=knowledgebase&amp;category={$category.id}&amp;sid={$sid}">{text value=$category.name}</a>
{/if}
{/foreach}