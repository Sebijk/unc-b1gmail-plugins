<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>Calendar Day View</title>
    
	<!-- meta -->
	<meta http-equiv="content-type" content="text/html; charset={$charset}" />
	
	<!-- links -->
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<link href="{$tpldir}style/loggedin.css" rel="stylesheet" type="text/css" />
	<link href="{$tpldir}style/dtree.css" rel="stylesheet" type="text/css" />
	
	<!-- client scripts -->
	<script language="javascript">
	<!--
		var currentSID = '{$sid}';
		var tplDir = '{$tpldir}';
	//-->
	</script>
	<script src="clientlang.php?sid={$sid}" type="text/javascript" language="javascript"></script>
	<script src="{$tpldir}js/common.js" type="text/javascript" language="javascript"></script>
	<script src="{$tpldir}js/loggedin.js" type="text/javascript" language="javascript"></script>
	<script src="clientlib/dtree.js" type="text/javascript" language="javascript"></script>
	<script src="clientlib/overlay.js" type="text/javascript" language="javascript"></script>
	<script src="clientlib/autocomplete.js" type="text/javascript" language="javascript"></script>
	<!--[if lt IE 7]>
	<script defer type="text/javascript" src="clientlib/pngfix.js"></script>
	<![endif]-->
</head>

<body onload="initCalendar()">
	<div id="calendarDayBody">
		<table class="calendarDayBody">
		{section name=halfHours start=0 loop=48}
		<tr>
		{if $smarty.section.halfHours.index%2==0}
			<td class="calendarDayTimeCell" rowspan="2">
				<div class="calendarDayTimeCellText"><a href="organizer.calendar.php?action=addDate&date={$dateStart}&time={halfHourToTime value=$smarty.section.halfHours.index dateStart=$dateStart}&sid={$sid}" target="_top">{halfHourToTime value=$smarty.section.halfHours.index}</a></div>
			</td>
		{/if}
		{if $smarty.section.halfHours.index==0}
			<td class="calendarDaySepCell" rowspan="48"></td>
			<td class="calendarDaySepCell2" rowspan="48"></td>
		{/if}
			<td class="calendarDayCell{if $smarty.section.halfHours.index%2}2{/if}{if $smarty.section.halfHours.index>=$dayStart && $smarty.section.halfHours.index<$dayEnd}_day{/if}" id="timeRow_{$smarty.section.halfHours.index}">
				&nbsp;
			</td>
		</tr>
		{/section}
		</table>
	</div>

	<script language="javascript">
	<!--
		function tctz_getDiffGMT() {ldelim}
			var rightNow = new Date();
			var date1 = new Date(rightNow.getFullYear(), 0, 1, 0, 0, 0, 0);
			var temp = date1.toGMTString();
			var date2 = new Date(temp.substring(0, temp.lastIndexOf(" ")-1));
			var hoursDiffStdTime = (date1 - date2) / (1000 * 60 * 60);
			return hoursDiffStdTime*60*60;
		{rdelim}
		var calendarDayStart = {$dayStart},
			calendarDayEnd = {$dayEnd},
			calendarDates = [],
			tzOffset = tctz_getDiffGMT();
		tzOffset = (tzOffset - {$tctz_offset});
		calendarDateClick = function(id) {ldelim}
			var parts = id.split('_');
			showCalendarDate(parts[1], parseInt(parts[2]) + tzOffset, parseInt(parts[3]) + tzOffset, true)
		{rdelim}
		{foreach from=$dates item=date}
		{if ($date.flags&1)==0}
		calendarDates.push([
			{$date.id},
			{$date.startdate} - tzOffset,
			{$date.enddate} - tzOffset,
			"{text escape=true noentities=true value=$date.title}",
			{$groups[$date.group].color}
		]);
		{/if}
		{/foreach}
	//-->
	</script>
</body>

</html>
