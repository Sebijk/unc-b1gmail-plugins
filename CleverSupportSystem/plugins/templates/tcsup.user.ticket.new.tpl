<div id="contentHeader">
	<div class="left">
		<i class="fa fa-plus-circle" aria-hidden="true"></i>
		{lng p="tcsup.neues_ticket"}
	</div>
</div>

<div class="scrollContainer"><div class="pad">
{if $errorStep}
<div class="note">
	{$errorInfo}
</div>
<br />
{/if}
<form name="f1" method="post" action="{$tcsup_url}&amp;module=tickets&amp;do=new&amp;sid={$sid}">
	<table class="listTable">
		<tr>
			<th class="listTableHead" colspan="2"> {lng p="tcsup.neues_ticket"}</th>
		</tr>
		<tr>
			<td class="listTableLeft">* <label for="type">{lng p="subject"}:</label></td>
			<td class="listTableRight">
				<input type="text" name="subject" id="subject" value="{if isset($smarty.request.subject)}{text value=$smarty.request.subject allowEmpty=true}{/if}" style="width:350px;" />
			</td>
		</tr>
		<tr>
			<td class="listTableLeft">* {lng p="tcsup.prioritaet"}:</td>
			<td class="listTableRight">
				<select name="priority" id="priority">
					<option value="1"{if isset($smarty.request.priority) && $smarty.request.priority==1} selected="selected"{/if}>{lng p="prio_1"}</option>
					<option value="0"{if empty($smarty.request.priority)} selected="selected"{/if}>{lng p="prio_0"}</option>
					<option value="-1"{if isset($smarty.request.priority) &&  $smarty.request.priority==-1} selected="selected"{/if}>{lng p="prio_-1"}</option>
				</select>
			</td>
		</tr>
				
		<tr>
			<td class="listTableLeftDescBottomLine" style="height: 2px; overflow: hidden; font-size: 1px; width: auto;">&nbsp;</td>
			<td class="listTableLeftDescBottomLine listTableLeftDescTopLine" style="height: 2px; overflow: hidden; font-size: 1px; width: auto;">&nbsp;</td>
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
				<input type="hidden" name="attachments" value="{if isset($mail.attachments)}{text value=$mail.attachments allowEmpty=true}{/if}" id="attachments" />
				<div id="attachmentList"></div>
				<div style="float:left">
					<a href="javascript:addAttachment('{$sid}')"><i class="fa fa-plus-circle" aria-hidden="true" style="width: 20px;"></i> {lng p="add"}</a>
				</div>
			</td>
		</tr>
		
		<tr>
			<td class="listTableLeft">&nbsp;</td>
			<td class="listTableRight">
				<input type="submit" value="{lng p="tcsup.ticket_erstellen"}" />
				<input type="reset" value="{lng p="reset"}" onclick="return askReset();"/>
			</td>
		</tr>
	</table>
</form>

<script type="text/javascript">
<!--
	{if $errorStep}
	{foreach from=$invalidFields item=field}
		markFieldAsInvalid('{$field}');
	{/foreach}
	{/if}
		
//-->
</script>

<div style="display: none">
  <div id="composeHeader"></div>
  <div id="contentHeader"></div>
  <div id="contentFooter"></div>
  <div id="composeText"></div>
</div>
<script type="text/javascript">var editor = false;</script>
</div></div>