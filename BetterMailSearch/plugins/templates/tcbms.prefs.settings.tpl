<script type="text/javascript">
function checkOptimizePrefs()
{ldelim}
	var indexOptimierenVZeit = EBID('id_index_optimieren_vzeit');
	var indexOptimierenZeit = EBID('id_index_optimieren_zeit');
	
	indexOptimierenZeit.readOnly = true;
	
	if(indexOptimierenVZeit.checked)
		indexOptimierenZeit.readOnly = false;
{rdelim}

function checkEnginePrefs()
{ldelim}
	var engine = EBID('id_engine');
	var engineOptionen = EBID('id_engine_zsl_optionen');
	
	engineOptionen.style.display = 'none';
	if(engine.selectedIndex == 1 && engine[1].value == 'zsl')
		engineOptionen.style.display = '';
{rdelim}
</script>
<form action="{$pageURL}&sid={$sid}&action=settings&do=save" method="post" onsubmit="spin(this)">
	<fieldset>
		<legend>{lng p="common"}</legend>
		
		<table>
			<tr style="display: none">
				<td class="td1" width="220">Engine:</td>
				<td class="td2">
					<select name="engine" id="id_engine" onchange="checkEnginePrefs();">
						<option value="mysql"{if $tcbms_prefs.engine == "mysql"} selected="selected"{/if}>MySQL</option>
						<option value="zsl"{if $tcbms_prefs.engine == "zsl"} selected="selected"{/if}>{lng p="tcbms.zsl"}</option>
					</select>
				</td>
			</tr>
			<tr id="id_engine_zsl_optionen" style="display: none">
				<td class="td1" width="220">{lng p="tcbms.zsl_speicherort"}:</td>
				<td class="td2">
					<input type="text" name="zsl_speicherort" value="{text value=$tcbms_prefs.zsl_speicherort}" size="45" /><br />
					<small>({lng p="tcbms.zsl_speicherort_warnung"})</small>
				</td>
			</tr>
			<tr>
				<td class="td1">{lng p="tcbms.index_optimieren"}:</td>
				<td class="td2">
					<input type="radio" name="index_optimieren" value="sofort" onchange="checkOptimizePrefs()"{if $tcbms_prefs.index_optimieren == "sofort"} checked="checked"{/if} /> {lng p="tcbms.index_sofort"}<br />
					<input id="id_index_optimieren_vzeit" type="radio" name="index_optimieren" value="zeit" onchange="checkOptimizePrefs()"{if $tcbms_prefs.index_optimieren == "zeit"} checked="checked"{/if} /> {lng p="tcbms.index_zeit"} <input id="id_index_optimieren_zeit" type="text" name="index_optimieren_zeit" value="{text value=$tcbms_prefs.index_optimieren_zeit allowEmpty=1}" size="4" /> {lng p="tcbms.minuten"}<br />
					<input type="radio" name="index_optimieren" value="nie" onchange="checkOptimizePrefs()"{if $tcbms_prefs.index_optimieren == "nie"} checked="checked"{/if} /> {lng p="tcbms.index_nie"}<br />
				</td>
			</tr>
			<tr>
				<td class="td1" width="220">{lng p="tcbms.max_email_groesse"}</td>
				<td class="td2">
					<input type="text" name="email_groesse" value="{text value=$tcbms_prefs.email_groesse}" size="8" /> KB
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset>
		<legend>{lng p="search"}</legend>
		<table>
			<tr>
				<td class="td1" width="220">{lng p="tcbms.soft_limit"}:</td>
				<td class="td2">
					{lng p="tcbms.soft_limit_text_1"} <input type="text" name="treffer_softlimit" value="{text value=$tcbms_prefs.treffer_softlimit allowEmpty=1}" size="4" /> {lng p="tcbms.soft_limit_text_2"}
				</td>
			</tr>
			<tr>
				<td class="td1">{lng p="tcbms.detail_ansicht_anzeigen"}:</td>
				<td class="td2">
					<input type="checkbox" name="detail_ansicht_anzeigen" value="1"{if $tcbms_prefs.detail_ansicht_anzeigen} checked="checked"{/if} />
				</td>
			</tr>
			<tr>
				<td class="td1">{lng p="tcbms.wahrscheinlichkeit_anzeigen"}:</td>
				<td class="td2">
					<input type="checkbox" name="wahrscheinlichkeit_anzeigen" value="1"{if $tcbms_prefs.wahrscheinlichkeit_anzeigen} checked="checked"{/if} />
				</td>
			</tr>
			<tr>
				<td class="td1">{lng p="tcbms.platzhalter_erlauben"}:</td>
				<td class="td2">
					<input type="checkbox" name="platzhalter_erlauben" value="1"{if $tcbms_prefs.platzhalter_erlauben} checked="checked"{/if} /><br />
					<small>({lng p="tcbms.platzhalter_erlauben_hinweis"})</small>
				</td>
			</tr>
		</table>
	</fieldset>
	<div style="float:right;">
		<input type="submit" class="button" value=" {lng p="save"} " />&nbsp;
	</div>
</form>
<script type="text/javascript">checkOptimizePrefs();checkEnginePrefs();</script>
