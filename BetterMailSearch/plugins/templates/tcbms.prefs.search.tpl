<form action="{$pageURL}&sid={$sid}&action=search" method="post" onsubmit="spin(this)">
<fieldset>
	<legend>{lng p="search"}</legend>
	<input type="text" name="q" value="{text value=$q}" size="80" /> <input type="submit" class="button" value="{lng p="ok"}" />
</fieldset>
</form>

{php}
echo count($this->_tpl_vars['hits']);
{/php}
 Treffer
<table class="list">
	<tr>
		<th width="50">Mail-ID</th>
		<th width="50">Score <img src="{$tpldir}images/sort_desc.png" border="0" alt="" width="7" height="6" align="absmiddle" /></th>
		<th width="200">From</th>
		<th>{lng p="subject"}</th>
	</tr>
{foreach from=$hits item=hit}
	{cycle name=class values="td1,td2" assign=class}
	<tr class="{$class}">
		<td align="center">{$hit->mailid}</td>
		<td>{$hit->score*100|string_format:"%.2f"}%</td>
		<td>{php}global $currentCharset; echo htmlspecialchars(iconv('utf-8', $currentCharset, $this->_tpl_vars['hit']->from));{/php}</td>
		<td align="center">{php}global $currentCharset; echo iconv('utf-8', $currentCharset, $this->_tpl_vars['hit']->subject);{/php}</td>
	</tr>
{/foreach}
<table>