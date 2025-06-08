<fieldset>
	<legend>{lng p="common"}</legend>

	<form action="{$pageURL}&amp;sid={$sid}&amp;action=settings&amp;do=save" method="post" onsubmit="spin(this)">
	{if $erfolg}<div class="alert alert-success">{$erfolg}</div>{/if}

		<div class="mb-3 row">
			<label class="col-sm-2 col-form-label" for="schluessellaenge">{lng p="tccme.schluessellaenge"}</label>
			<div class="col-sm-10">
					<select id="schluessellaenge" name="schluessellaenge" class="form-select">
						{if $tccme_prefs.schluessellaenge == 2048}<option selected="selected">2048</option>{/if}
						<option{if $tccme_prefs.schluessellaenge == 4096} selected="selected"{/if}>4096 ({lng p="tccme.schluessellaenge_empfohlen"})</option>
						<option{if $tccme_prefs.schluessellaenge == 8192} selected="selected"{/if}>8192</option>
					</select>
				</label>
			</div>
		</div>
		

		<div class="text-end">
			<input type="submit" name="save" value="{lng p="save"}" class="btn btn-primary" />
		</div>
	</form>
</fieldset>