<form method="post" name="f1" action="{$pageURL}&amp;action=knowledgebase&amp;do=editArticle&amp;sid={$sid}&amp;id={$tcsup_data.id}" onsubmit="editor.submit();spin(this);">
	<fieldset>
		<legend>{lng p="tcsup.artikel_hinzufuegen"}</legend>
			<table width="100%">
				<tr>
					<td width="40" valign="top" rowspan="4"><img src="{$tpldir}images/extension.png" border="0" alt="" width="32" height="32" /></td>
					<td class="td1" width="150">{lng p="tcsup.artikel"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="title" value="{text value=$tcsup_data.title}" /></td>
				</tr>
				<tr>
					<td class="td1" width="150">{lng p="tcsup.beschreibung"}:</td>
					<td class="td2"><input type="text" style="width:85%;" name="short_body" value="{text value=$tcsup_data.short_body allowEmpty=true}" /></td>
				</tr>
				<tr>
					<td class="td1">{lng p="tcsup.in_kategorien"}:</td>
					<td class="td2">
						<select name="parent" class="smallInput">
							<option value="null">------------</option>
							{foreach from=$tcsup_categoryDropdown key=language item=category}
								<optgroup label="{text value=$languages[$language].title}">
								{tcsup_categoryOptions categories=$category default=$tcsup_data.kbcategory_id}
								</optgroup>
							{/foreach}
						</select>
					</td>
				</tr>
				<td colspan="2" style="border: 1px solid #DDDDDD;background-color:#FFFFFF;">
					<textarea name="body" id="body" class="plainTextArea" style="width:100%;height:320px;">{$tcsup_data.body}</textarea>
					<script language="javascript" src="../clientlib/wysiwyg.js"></script>
					<script language="javascript">
					<!--
						var editor = new htmlEditor('body', '{$usertpldir}/images/editor/');
						editor.init();
						registerLoadAction('editor.start()');
					//-->
					</script>
				</td>
			</table>
		
			<p align="right">
				<input type="submit" class="button" value=" {lng p="save"} " />
			</p>
	</fieldset>
</form>