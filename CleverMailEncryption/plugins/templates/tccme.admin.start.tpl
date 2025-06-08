<span id="tccme_container">
<fieldset>
	<legend>{lng p="overview"}</legend>

	{if !$tccme_groupCount}<div class="alert alert-warning">{lng p="tccme.keine_gruppe_aktiviert"}</div>{/if}

	<div class="row">
		<div class="col-md-6">
			<div class="row">
				<label class="col-sm-4 col-form-label">{$tccme_name}</label>
				<div class="col-sm-8">
					<div class="form-control-plaintext">{$tccme_version}</div>
				</div>
			</div>
			<div class="row">
				<label class="col-sm-4 col-form-label">{lng p="tccme.openssl_support"}</label>
				<div class="col-sm-8">
					<div class="form-control-plaintext"><img src="./templates/images/{$tccme_opensslSupport}.png" border="0" alt="" width="16" height="16" /></div>
				</div>
			</div>
			<div class="row">
				<label class="col-sm-4 col-form-label">{lng p="tccme.verschluesselte_mails"}</label>
				<div class="col-sm-8">
					<div class="form-control-plaintext">{$tccme_mailCount}</div>
				</div>
			</div>
		</div>
	</div>
</fieldset>
{if $tccme_hasQueue}
<fieldset>
	<legend>{lng p="tccme.warteschlange_abarbeiten"}</legend>
	<div class="mb-3 row">
		<label class="col-sm-10 col-form-label">{lng p="tccme.warteschlange_abarbeiten_beschreibung"}</label>
		<div class="col-sm-10">
			<div class="form-control-plaintext">
			<input type="submit" class="btn btn-primary" name="optimieren" value="{lng p="tccme.warteschlange_abarbeiten"}" onclick="spin(EBID('tccme_container')); workOffQueue();" />
					<noscript><br /><small>({lng p="tccme.javascript_aktivieren"})</small></noscript>
			</div>
		</div>
	</div>
</fieldset>
{/if}
</span>

	</div>
	<div class="card-footer m-0 p-0">
		<h3 class="m-4">{lng p="notices"}</h3>
		<table class="table table-vcenter table-striped card-table">
			{foreach from=$notices item=notice}
				<tr>
					<td class="align-top text-end" style="width: 50px;">
						{if $notice.type == 'debug'}
							<i class="fa-solid fa-bug text-danger"></i>
						{elseif $notice.type == 'info'}
							<i class="fa-solid fa-circle-info text-info"></i>
						{elseif $notice.type == 'warning'}
							<i class="fa-solid fa-triangle-exclamation text-warning"></i>
						{elseif $notice.type == 'error'}
							<i class="fa-regular fa-circle-xmark text-red"></i>
						{else}
							<i class="fa-solid fa-puzzle-piece text-cyan"></i>
						{/if}
					</td>
					<td class="align-top">{$notice.text}</td>
					<td class="align-top" style="width: 50px;">
						{if isset($notice.link)}
							<a href="{$notice.link}sid={$sid}"><i class="fa-solid fa-square-arrow-up-right"></i></a>
						{else}&nbsp;{/if}
					</td>
				</tr>
			{/foreach}
		</table>
	</div>


<center id="status_container" style="display: none"><span id="status">0</span> {lng p="tccme.mails_verarbeitet"}...</center>

<script type="text/javascript">{literal}

function workOffQueue()
{
	rc_statuscontainerdiv = EBID('status_container');
	rc_statuscontainerdiv.style.display = '';
	MakeXMLRequest('{/literal}{$pageURL}&sid={$sid}&do=workOffQueue{literal}', _workOffQueue);
}

var tccmeCounter = 0, tccmeErrors = 0;
function _workOffQueue(e)
{
	if(e.readyState == 4)
	{
		var text = e.responseText;
		var counter = parseFloat(text);
		if(text.indexOf('DONE') != -1) {
			document.location.href = '{/literal}{$pageURL}&sid={$sid}{literal}';
		}
		else if(text.length == 0 || isNaN(counter))
		{
			tccmeErrors++;
			if(tccmeErrors > 10) {
				document.location.href = '{/literal}{$pageURL}&sid={$sid}{literal}';
			}
			rc_statuscontainer = EBID('status_container');
			rc_statuscontainer.innerHTML = "{/literal}{lng p="error"}... {literal}" + tccmeErrors + "/10";
			rc_statuscontainer.innerHTML = text;
			workOffQueue();
		}
		else
		{
			tccmeErrors = 0;
			tccmeCounter += counter;
			rc_statusdiv = EBID('status');
			rc_statusdiv.innerHTML = tccmeCounter;
			workOffQueue();
		}
	}
}
{/literal}</script>