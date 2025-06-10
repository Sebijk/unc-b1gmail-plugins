
<div id="contentHeader">
	<div class="left">
		<i class="fa fa-tachometer" aria-hidden="true"></i>
		{lng p="tcsup.tickets"}
	</div>
</div>

<div class="scrollContainer">
	<div class="pad">


		<a href="#content" onclick="EBID('content').focus();">
			<i class="fa fa-plus-circle" aria-hidden="true"></i>
			{lng p="tcsup.kommentar_hinzufuegen"}
		</a><br /><br />

		{foreach from=$tcsup_ticket.contents key=cid item=content}
		<table class="listTable">
			<tr>
				<th class="listTableHead" style="text-align: left; padding-left: 5px"> {if $content.admin}{lng p="tcsup.ticket_von_admin"}{else}{lng p="tcsup.ticket_von_user"}{/if} - {date timestamp=$content.date nice=true elapsed=true}</th>
			</tr>
			<tr>
				<td class="listTableRight">
					{if isset($content.content)}{$content.content}{/if}
					<br />
					<br />
				</td>
			</tr>
			{if !empty($tcsup_ticket.files[$content.id])}
			<tr>
				<td class="listTableRight" style="border-top: 1px solid #ddd; padding: 5px">
					{foreach from=$tcsup_ticket.files[$content.id] item=file}
						<a href="{$tcsup_url}&amp;module=tickets&amp;do=getFile&amp;file={text value=$file.id}&amp;sid={$sid}">
							<i class="fa fa-cloud fa-paperclip"></i> {text value=$file.dateiname}
						</a>
					{/foreach}
				</td>
			</tr>
			{/if}
		</table>
		<br />
		{/foreach}

		<form name="f1" method="post" action="{$tcsup_url}&amp;module=tickets&amp;do=addComment&amp;ticket={text value=$tcsup_ticket.id}&amp;sid={$sid}">
			<table class="listTable">
				<tr>
					<th class="listTableHead" colspan="2"> {lng p="tcsup.kommentar_hinzufuegen"}</th>
				</tr>				
				<tr>
					<td class="listTableLeftDescBottomLine" colspan="2" style="text-align: left">
						<input type="checkbox" name="close" id="close" value="1" />
						<label for="close">{lng p="tcsup.geloest"}</label>
					</td>
				</tr>
				
				<tr>
					<td class="listTableCompose" colspan="2">
						<textarea class="composeTextarea" name="content" id="content" style="width:100%;height:180px;">{if isset($smarty.request.content)}{text value=$smarty.request.content allowEmpty=true}{/if}</textarea>
					</td>
				</tr>
						
				<tr>
					<td class="	listTableLeftDescTopLine" style="height: 2px; overflow: hidden; font-size: 1px; width: auto;">&nbsp;</td>
					<td class="listTableLeftDescBottomLine listTableLeftDescTopLine" style="height: 2px; overflow: hidden; font-size: 1px; width: auto;">&nbsp;</td>
				</tr>
						
				<tr>
					<td class="listTableLeft">{lng p="attachments"}:</td>
					<td class="listTableRight">
						<input type="hidden" name="attachments" value="{text value=$mail.attachments allowEmpty=true}" id="attachments" />
						<div id="attachmentList"></div>
						<div style="float:left">
							<a href="javascript:addAttachment('{$sid}')"><i class="fa fa-plus-circle" aria-hidden="true"></i> {lng p="add"}</a>
						</div>
					</td>
				</tr>
				
				<tr>
					<td class="listTableLeft">&nbsp;</td>
					<td class="listTableRight">
						<input type="submit" value="{lng p="tcsup.kommentar_hinzufuegen"}" />
						<input type="reset" value="{lng p="reset"}" onclick="return askReset();"/>
					</td>
				</tr>
			</table>
		</form>
		<div style="display: none">
		<div id="composeHeader"></div>
		<div id="contentHeader"></div>
		<div id="contentFooter"></div>
		<div id="composeText"></div>
		</div>
		<script type="text/javascript">var editor = false;</script>
	</div>
</div>