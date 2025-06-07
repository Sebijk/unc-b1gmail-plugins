<script type="text/javascript">
spin = function() {ldelim}{rdelim} // don't spin!
</script>

<form method="post" name="f1" action="{$pageURL}&amp;sid={$sid}">
	<input type="hidden" name="singleAction" id="singleAction" value="" />
	<input type="hidden" name="singleID" id="singleID" value="" />
	<fieldset>
		<legend>{lng p="domains"}</legend>
		<table class="list">
			<tr>
				<th width="40">{lng p="tcbrn.aktiviert"}</th>
				<th width="25" style="text-align:center;">
					<a href="javascript:invertSelection(document.forms.f1,'domains');">
						<img src="{$tpldir}images/dot.png" border="0" alt="" width="10" height="8" />
					</a>
				</th>
				<th>{lng p="tcbrn.domain"}</th>
				<th>{lng p="projecttitle"}</th>
				<th>{lng p="template"}</th>
				<th>{lng p="language"} / {lng p="country"}</th>
				<th width="55">&nbsp;</th>
			</tr>
			{foreach from=$tcbrn_domains item=domain}
			{cycle name=class values="td1,td2" assign=class}
			<tr class="{$class}">
				<td>
					<a href="javascript:singleAction('{if $domain.active}de{/if}activate','{$domain.domainid}');" title="{if !$domain.active}{lng p='tcbrn.jetzt_aktivieren'}{else}{lng p='tcbrn.jetzt_deaktivieren'}{/if}"><img src="../plugins/templates/images/tcbrn_{if !$domain.active}not{/if}active.png" border="0" alt="" width="16" height="16" /></a>
				</td>
				<td align="center"><input type="checkbox" name="domains[]" value="{$domain.domainid}" /></td>
				<td>{text value=$domain.domain}<br /><small>({if $domain.mode == 'standard'}{lng p="tcbrn.modus_standard"}{elseif $domain.mode == 'exact'}{lng p="tcbrn.modus_exakt"}{else}{lng p="expression"}{/if})</small></td>
				<td>{text value=$domain.title}</td>
				<td>{text value=$domain.template}</td>
				<td>{text value=$languages[$domain.language].title} / {text value=$countries[$domain.country]}</td>
				<td>
					<a href="{$pageURL}&amp;action=domain&amp;id={$domain.domainid}&amp;sid={$sid}" title="{lng p="edit"}">
						<img src="{$tpldir}images/edit.png" border="0" alt="{lng p="edit"}" width="16" height="16" />
					</a>
					<a href="javascript:singleAction('delete','{$domain.domainid}');" onclick="return confirm('{lng p="realdel"}');" title="{lng p="delete"}">
						<img src="{$tpldir}images/delete.png" border="0" alt="{lng p="delete"}" width="16" height="16" />
					</a>
				</td>
			</tr>
			{/foreach}
			
				<tr>
					<td class="footer" colspan="7">
						<div style="float:left;">
							{lng p="action"}: <select name="massAction" class="smallInput">
								<option value="-">------------</option>
								
								<optgroup label="{lng p="actions"}">
									<option value="activate">{lng p="tcbrn.aktivieren"}</option>
									<option value="deactivate">{lng p="tcbrn.deaktivieren"}</option>
									<option value="delete">{lng p="delete"}</option>
								</optgroup>
							</select>&nbsp;
						</div>
						<div style="float:left;">
							<input type="submit" class="button smallInput" name="executeMassAction" value=" {lng p="execute"} " />
						</div>
						<div style="float:right;padding-top:3px;">
							<a href="{$pageURL}&amp;action=domain&amp;sid={$sid}">
								<img src="{$tpldir_user}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcbrn.domain_hinzufuegen"}
							</a>
						</div>
					</td>
				</tr>
		</table>
	</fieldset>
</form>

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

<script type="text/javascript" src="{$updateURL}"></script>