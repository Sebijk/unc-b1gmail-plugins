
<h1><img src="{$tpldir}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="tcsup.neues_ticket"}</h1>

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
				<input type="text" name="subject" id="subject" value="{text value=$smarty.request.subject allowEmpty=true}" style="width:350px;" />
			</td>
		</tr>
		<tr>
			<td class="listTableLeft">* {lng p="tcsup.prioritaet"}:</td>
			<td class="listTableRight">
				<select name="priority" id="priority">
					<option value="1"{if $smarty.request.priority==1} selected="selected"{/if}>{lng p="prio_1"}</option>
					<option value="0"{if !$smarty.request.priority || $smarty.request.priority==0} selected="selected"{/if}>{lng p="prio_0"}</option>
					<option value="-1"{if $smarty.request.priority==-1} selected="selected"{/if}>{lng p="prio_-1"}</option>
				</select>
			</td>
		</tr>
				
		<tr>
			<td class="listTableLeftDescBottomLine" style="height: 2px; overflow: hidden; font-size: 1px; width: auto;">&nbsp;</td>
			<td class="listTableLeftDescBottomLine listTableLeftDescTopLine" style="height: 2px; overflow: hidden; font-size: 1px; width: auto;">&nbsp;</td>
		</tr>
		
		<tr>
			<td class="listTableCompose" colspan="2">
				<textarea class="composeTextarea" name="content" id="content" style="width:100%;height:180px;">{text value=$smarty.request.content allowEmpty=true}</textarea>
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
					<a href="javascript:addAttachment('{$sid}')"><img src="{$tpldir}images/li/ico_add.png" width="16" height="16" border="0" alt="" align="absmiddle" /> {lng p="add"}</a>
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

<script language="javascript">
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
