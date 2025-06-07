<form action="{$pageURL}&amp;sid={$sid}&amp;action=settings&amp;do=save" method="post" onsubmit="spin(this)">
	<fieldset>
		<legend>{lng p="common"}</legend>
		<table>
			<tr>
				<td class="td1" width="200"><label for="schluessellaenge">{lng p="tccme.schluessellaenge"}:</label></td>
				<td class="td2">
					<select id="schluessellaenge" name="schluessellaenge">
						<option{if $tccme_prefs.schluessellaenge == 512} selected="selected"{/if}>512</option>
						<option{if $tccme_prefs.schluessellaenge == 768} selected="selected"{/if}>768</option>
						<option value="1024"{if $tccme_prefs.schluessellaenge == 1024} selected="selected"{/if}>1024</option>
						<option{if $tccme_prefs.schluessellaenge == 2048} selected="selected"{/if}>2048 ({lng p="tccme.schluessellaenge_empfohlen"})</option>
						<option{if $tccme_prefs.schluessellaenge == 4096} selected="selected"{/if}>4096</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="td1" width="200"><label for="maxgroesse">{lng p="tccme.maxgroesse"}:</label></td>
				<td class="td2">
					<input type="text" id="maxgroesse" name="maxgroesse" value="{text value=$tccme_prefs.maxgroesse/1024 allowEmpty=1}" size="8" /> KiB
				</td>
			</tr>
		</table>
	</fieldset>
	<div style="float:right;">
		<input type="submit" class="button" value=" {lng p="save"} " />&nbsp;
	</div>
</form>