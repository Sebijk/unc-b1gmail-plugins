
<h1><img src="{$tpldir}images/li/ico_faq.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.knowledgebase"}</h1>

<small>{lng p="tcsup.breadcrumb"}: {include file=$tcsup_pageBreadcrumb} <b>&gt; {text value=$tcsup_article.title}</b></small>
<br /><br />
<table width="100%" cellpadding="5">
	<tr>
		<td valign="top">
			<table class="listTable">
				<tr>
					<th class="listTableHead">{text value=$tcsup_article.title}</th>
				</tr>
				<tr>
					<td class="listTableRight">
						{$tcsup_article.body}
						<br />
						<br />
					</td>
				</tr>
			</table>
		</td>
		<td width="200" valign="top">
			<table class="listTable">
				<tr>
					<th class="listTableHead">{lng p="tcsup.artikel_aktion"}</th>
				</tr>
				<tr>
					<td class="listTableRight">
						<div class="contentMenuIcons">
							&nbsp;<a href="#" onclick="openOverlay('{$tcsup_url}&article={$tcsup_article.id}&do=send&sid={$sid}', '{lng p="tcsup.overlay_artikel_verschicken"}', 450, 460, true);"><img src="{$tpldir}images/li/mail_redirect.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.artikel_verschicken"}</a><br />
							&nbsp;<a href="#" onclick="openWindow('{$tcsup_url}&article={$tcsup_article.id}&do=print&sid={$sid}', 'kb_print{$tcsup_article.id}', 560, 680, true)"><img src="{$tpldir}images/li/mail_print.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.artikel_drucken"}</a><br />
						</div>
					</td>
				</tr>
			</table><br />
			<table class="listTable">
				<tr>
					<th class="listTableHead">{lng p="tcsup.meinungen"}</th>
				</tr>
				<tr>
					<td class="listTableRight">
						<br />
						{if $tcsup_rating}
							<img width="16" height="16" src="{$tpldir}images/li/yes.png" alt="{lng p="tcsup.hilfreich"}" title="{lng p="tcsup.hilfreich"}" align="absmiddle" /> {$tcsup_rating.positive}% 
							<img width="16" height="16" src="{$tpldir}images/li/no.png" alt="{lng p="tcsup.nicht_hilfreich"}" title="{lng p="tcsup.nicht_hilfreich"}" align="absmiddle" /> {$tcsup_rating.negative}% 
						{else}
							<i>{lng p="tcsup.kein_rating"}</i>
						{/if}
						<br />
						<br />
						<b>{lng p="tcsup.ihre_meinung"}</b><br />
						<form action="{$tcsup_url}&article={$tcsup_article.id}&do=vote&sid={$sid}" method="post">
							<input type="radio" name="rating" id="rating_ok" value="ok" />
							<label for="rating_ok">
								{lng p="tcsup.hilfreich"}
							</label>
							<br />
							<input type="radio" name="rating" id="rating_nok" value="nok" />
							<label for="rating_nok">
								{lng p="tcsup.nicht_hilfreich"}
							</label>
							<br />
							<input type="submit" value="{lng p="ok"}" />
						</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>