<form method="post" name="f1" action="{$pageURL}&amp;action=knowledgebase&amp;do=addArticle&amp;sid={$sid}" onsubmit="editor.submit();spin(this);">
	<fieldset>
		<legend>{lng p="tcsup.artikel_hinzufuegen"}</legend>
		
			<table width="100%">
				<tr>
					<td width="40" valign="top" rowspan="4"><img src="{$tpldir}images/extension_add.png" border="0" alt="" width="32" height="32" /></td>
					<td class="td1" width="150">{lng p="tcsup.artikel"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="title" value="" /></td>
				</tr>
				<tr>
					<td class="td1" width="150">{lng p="tcsup.beschreibung"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="short_body" value="" /></td>
				</tr>
				<tr>
					<td class="td1">{lng p="tcsup.in_kategorien"}:</td>
					<td class="td2">
						<select name="parent" class="smallInput">
							<option value="null">------------</option>
							{foreach from=$tcsup_categoryDropdown key=language item=category}
								<optgroup label="{text value=$languages[$language].title}">
								{tcsup_categoryOptions categories=$category ignore=$tcsup_activeCategory default=$tcsup_defaultCategory}
								</optgroup>
							{/foreach}
						</select>
					</td>
				</tr>
				<td colspan="2" style="border: 1px solid #DDDDDD;background-color:#FFFFFF;">
					<textarea name="body" id="body" class="plainTextArea" style="width:100%;height:320px;"></textarea>
					<script language="javascript" src="../clientlib/wysiwyg.js"></script>
					<script language="javascript">
					<!--
						var editor = new htmlEditor('body', '{$tpldir_user}/images/editor/');
						editor.init();
						registerLoadAction('editor.start()');
					//-->
					</script>
				</td>
			</table>
		
			<p align="right">
				<input type="submit" class="button" value=" {lng p="add"} " />
			</p>
	</fieldset>
</form>