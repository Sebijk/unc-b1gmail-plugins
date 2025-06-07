<form method="post" name="f1" action="{$pageURL}&amp;action=domain&amp;id={$tcbrn_data.domainid}&amp;sid={$sid}" onsubmit="spin(this);">
	<fieldset>
		<legend>{if $tcbrn_data.domainid}{lng p="tcbrn.domain_bearbeiten"}{else}{lng p="tcbrn.domain_hinzufuegen"}{/if}</legend>
			<table width="100%">
				<tr>
					<td width="40" valign="top" rowspan="21"><img src="{$tpldir}images/extension{if !$tcbrn_data.domainid}_add{/if}.png" border="0" alt="" width="32" height="32" /></td>
					<td colspan="2" style="font-weight: bold">
						{lng p="tcbrn.domain"}
					</td>
				</tr>
				<tr>
					<td class="td1" width="200">
						<label for="active">
							{lng p="tcbrn.aktiviert"}:
						</label>
					</td>
					<td class="td2">
						<input type="checkbox" name="active" id="active" value="1"{if $tcbrn_data.active} checked="checked"{/if} />
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="domain">
							{lng p="tcbrn.domain"}:
						</label>
					</td>
					<td class="td2">
						<input type="text" style="width:85%;" name="domain" id="domain" value="{text value=$tcbrn_data.domain allowEmpty=1}" />
					</td>
				</tr>
				<tr>
					<td class="td1">
						{lng p="tcbrn.modus"}:
					</td>
					<td class="td2">
						<input type="radio" name="mode" id="modus_standard" value="standard"{if $tcbrn_data.mode == 'standard'} checked="checked"{/if} /> <label for="modus_standard">{lng p="tcbrn.modus_standard"} <small>({lng p="tcbrn.modus_standard_hinweis"})</small></label><br />
						<input type="radio" name="mode" id="modus_exact" value="exact"{if $tcbrn_data.mode == 'exact'} checked="checked"{/if} /> <label for="modus_exact">{lng p="tcbrn.modus_exakt"} <small>({lng p="tcbrn.modus_exakt_hinweis"})</small></label><br />
						<input type="radio" name="mode" id="modus_regex" value="regex"{if $tcbrn_data.mode == 'regex'} checked="checked"{/if} /> <label for="modus_regex">{lng p="expression"}</label><br />
					</td>
				</tr>
				<tr>
					<td colspan="2" style="font-weight: bold">
						{lng p="prefs"}
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="title">{lng p="projecttitle"}:</label>
					</td>
					<td class="td2"><input type="text" style="width:85%;" name="title" id="title" value="{text value=$tcbrn_data.title allowEmpty=1}" /></td>
				</tr>
				<tr>
					<td class="td1">
						<label for="selfurl">{lng p="selfurl"}:</label>
					</td>
					<td class="td2"><input type="text" style="width:85%;" name="selfurl" id="selfurl" value="{text value=$tcbrn_data.selfurl allowEmpty=1}" /></td>
				</tr>
				<tr>
					<td class="td1">
						<label for="selfurl">{lng p="logouturl"}:</label>
					</td>
					<td class="td2"><input type="text" style="width:85%;" name="logouturl" id="logouturl" value="{text value=$tcbrn_data.logouturl allowEmpty=1}" /></td>
				</tr>
				<tr>
					<td class="td1">
						<label for="xmailer">{lng p="tcbrn.xmailer"}:</label>
					</td>
					<td class="td2"><input type="text" style="width:85%;" name="xmailer" id="xmailer" value="{text value=$tcbrn_data.xmailer allowEmpty=1}" /></td>
				</tr>
				<tr>
					<td class="td1">
						<label for="template">{lng p="template"}:</label>
					</td>
					<td class="td2">
						<select name="template" id="template">
							<option value="">{lng p="tcbrn.default"}</option>
							{foreach from=$templates item=tpl}
								<option value="{$tpl}"{if $tpl==$tcbrn_data.template} selected="selected"{/if}>{text value=$tpl}</option>
							{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="domainlist">{lng p="tcbrn.domainliste"}:</label>
					</td>
					<td class="td2">
						<input type="checkbox" name="domainlist" id="domainlist" value="1" {if $tcbrn_data.domainlist}checked="checked" {/if}onchange="{literal}if(this.checked) { EBID('domain_table').style.display = ''; } else { EBID('domain_table').style.display = 'none'; } {/literal}" />
						<label for="domainlist">
							{lng p="tcbrn.domainliste_konfigurieren"}
						</label>
						<table class="list" id="domain_table">
							<tr>
								<th width="65">
									{lng p="tcbrn.domainliste_sichtbar"}
									<a href="javascript:invertSelection(document.forms.f1,'domainlist_domains');">
										<img src="{$tpldir}images/dot.png" border="0" alt="" width="10" height="8" />
									</a>
								</th>
								<th width="65">
									{lng p="tcbrn.domainliste_standard"}
								</th>
								<th>
									{lng p="tcbrn.domainliste_domain"}
								</th>
							</tr>
							{foreach from=$domainList item=domain}
							{cycle name=class values="td1,td2" assign=class}
							<tr class="{$class}">
								<td align="center" style="text-align: center">
									<input type="checkbox" name="domainlist_domains[]" value="{text value=$domain}" {if array_search($domain, $tcbrn_data.domainlist_domains) !== false}checked="checked" {/if}/>
								</td>
								<td align="center" style="text-align: center">
									<input type="radio" name="domainlist_default" value="{text value=$domain}" {if $tcbrn_data.domainlist_default == $domain}checked="checked" {/if}/>
								</td>
								<td>
									{text value=$domain}
								</td>
							</tr>
							{/foreach}
						</table>
						{if !$tcbrn_data.domainlist}
						<script type="text/javascript">
							EBID('domain_table').style.display = 'none';
						</script>
						{/if}
					</td>
				</tr>
				<tr>
					<td colspan="2" style="font-weight: bold">
						{lng p="ssl"}
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="selfurl">{lng p="ssl_url"}:</label>
					</td>
					<td class="td2"><input type="text" style="width:85%;" name="ssl_url" id="ssl_url" value="{text value=$tcbrn_data.ssl_url allowEmpty=1}" /></td>
				</tr>
				<tr>
					<td class="td1">
						<label for="ssl_login_option">{lng p="ssl_login_option"}?</label>
					</td>
					<td class="td2">
						<input name="ssl_login_option" type="hidden" value="no" />
						<input name="ssl_login_option"{if $tcbrn_data.ssl_login_option=='yes'} checked="checked"{/if} id="ssl_login_option" value="yes" type="checkbox" />
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="ssl_login_enable">{lng p="ssl_login_enable"}?</label>
					</td>
					<td class="td2">
						<input name="ssl_login_enable" type="hidden" value="no" />
						<input name="ssl_login_enable"{if $tcbrn_data.ssl_login_enable=='yes'} checked="checked"{/if} id="ssl_login_enable" value="yes" type="checkbox" />
					</td>
				</tr>
				<tr>
					<td colspan="2" style="font-weight: bold">
						{lng p="defaults"}
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="country">{lng p="country"}:</label>
					</td>
					<td class="td2">
						<select name="country" id="country">
							<option value="">{lng p="tcbrn.default"}</option>
							{foreach from=$countries item=country key=countryID}
								<option value="{$countryID}"{if $countryID==$tcbrn_data.country} selected="selected"{/if}>{text value=$country}</option>
							{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="language">{lng p="language"}:</label>
					</td>
					<td class="td2">
						<select name="language" id="language">
							<option value="">{lng p="tcbrn.default"}</option>
							{foreach from=$languages item=lang key=langID}
								<option value="{$langID}"{if $langID==$tcbrn_data.language} selected="selected"{/if}>{text value=$lang.title}</option>
							{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="font-weight: bold">
						{lng p="signup"}
					</td>
				</tr>
				<tr>
					<td class="td1">
						{lng p="stateafterreg"}:
					</td>
					<td class="td2">
						<select name="usr_status">
							<option value="">{lng p="tcbrn.default"}</option>
							<option value="no"{if $tcbrn_data.usr_status=='no'} selected="selected"{/if}>{lng p="active"}</option>
							<option value="locked"{if $tcbrn_data.usr_status=='locked'} selected="selected"{/if}>{lng p="notactivated"}</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td1">
						<label for="std_gruppe">{lng p="stdgroup"}:</label>
					</td>
					<td class="td2">
						<select name="std_gruppe">
							<option value="">{lng p="tcbrn.default"}</option>
							{foreach from=$groups item=group}
								<option value="{$group.id}"{if $tcbrn_data.std_gruppe==$group.id} selected="selected"{/if}>{text value=$group.title}</option>
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