<form method="post" name="f1" action="{$pageURL}&amp;action=knowledgebase&amp;do=editCategory&amp;id={$tcsup_data.id}&amp;sid={$sid}">
	<fieldset>
		<legend>{lng p="tcsup.kategorie_bearbeiten"}</legend>
			<table width="100%">
				<tr>
					<td width="40" valign="top" rowspan="3"><img src="{$tpldir}images/cache.png" border="0" alt="" width="32" height="32" /></td>
					<td class="td1" width="150">{lng p="tcsup.kategorie"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="name" value="{text value=$tcsup_data.name}" /></td>
				</tr>
				<tr>
					<td class="td1" width="150">{lng p="tcsup.beschreibung"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="description" value="{text value=$tcsup_data.description allowEmpty=true}"" /></td>
				</tr>
				<tr>
					<td class="td1">{lng p="tcsup.unterkategorie_von"}:</td>
					<td class="td2">
						<select name="parent" class="smallInput">
							<option value="null">------------</option>
							{foreach from=$tcsup_categoryDropdown key=language item=category}
								<option value="{$language}"{if $tcsup_data.parent == 0 && $tcsup_data.language == $language} selected="selected"{/if}>{text value=$languages[$language].title}</option>
								{tcsup_categoryOptions categories=$category ignore=$tcsup_activeCategory default=$tcsup_data.parent}
							{/foreach}
						</select>
					</td>
				</tr>
			</table>
		
			<p align="right">
				<input type="submit" class="button" value=" {lng p="save"} " />
			</p>
	</fieldset>
</form>