<a href="{$tcsup_url}&amp;sid={$sid}">{lng p="tcsup.knowledgebase"}</a>
{foreach from=$tcsup_breadcrumb item=category name=category}
{if $tcsup_categoryActive == $category.id}
<b> &gt; {text value=$category.name}</b>
{else}
 &gt; <a href="{$tcsup_url}&amp;category={$category.id}&amp;sid={$sid}">{text value=$category.name}</a>
{/if}
{/foreach}