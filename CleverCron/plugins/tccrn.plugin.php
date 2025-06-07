<?php
/**
 * CleverCron
 *
 * @link       http://www.thinkclever.ch/
 * @copyright  2007-2013 ThinkClever IT Solutions
 *
 * TODO:
 *  - Beispiele beim Erstellen einer Aufgabe
 */

/**
 * CleverCron
 *
 */
class TCCronPlugin extends BMPlugin {

  function TCCronPlugin() {
    $this->name = 'CleverCron';
    $this->author = 'ThinkClever GmbH';
    $this->web = 'http://www.thinkclever.ch/';
    $this->mail = 'info@thinkclever.ch';
    $this->version = '1.3.0';
    $this->designedfor = '7.3.0';
    $this->type = BMPLUGIN_DEFAULT;

    $this->admin_pages = true;
    $this->admin_page_title = $this->name;
    $this->admin_page_icon = 'tccrn_icon32.png';

    $this->website = 'http://my.b1gmail.com/details/47/';
    $this->update_url = 'http://code.thinkclever.net/b1gmail/plugins/update/index.php/-' . md5(B1GMAIL_LICNR . md5(B1GMAIL_SIGNKEY)) . '-/';
  }

  function Install() {
    global $db, $mysql;
    $databaseStructure = // Tables: 2; Hash: 50c5cf2d0f0b268360de51cece551a7f
        'rZNNb8IwDIb/ypQLIO1Av4Clpx13GJu47YSi1JRoIaAkrZiq/vfZASooSBNilypxnOd1ar+Cx7x'
      . 'xPI45a3YWWi+lNcudrkplltJuDcvFIWXC2UqBLhxFXnij+BgXk8MiHFO6KliueISBCCPK+GEUjZ'
      . '4q41RpIJzFeIZq8w/aJLhJOPtcvNEuzef4zehyypmo/HapjLSwAeNZ3hL3UlFIr2roFMeceWV+g'
      . 'urophZmXAqFQEuZZ2QU98J9d1xE1MLKtbDDOMvuJCe9mp0XvnIndowRMNVmOFgpo9waisHzAFOs'
      . 'x9UfSo7PqCeHa6wnm57LYp4Wzkuh9Ul42nXnvudkPa6B/b9wJz0uDVMhvDhxqScodR902oNSVx+'
      . 'Gzs6hOLx6Wz4+ge3xzxWwh+CwiDw3DdZ4f118HUNXXmvpJg3RtXsdeKyldLcdHF05eBaeoqGGrp'
      . 'lHC6ePPWXMGyzzFw==';
    $databaseStructure = unserialize(gzinflate(base64_decode($databaseStructure)));
    $structure = array();
    foreach ($databaseStructure as $tableName => $data) {
      $tableName = str_replace('{pre}', $mysql['prefix'], $tableName);
      $structure[$tableName] = $data;
    }
    SyncDBStruct($structure);

    // prefs row?
    $res = $db->Query('SELECT COUNT(*) FROM {pre}tccrn_plugin_settings');
    list ($rowCount) = $res->FetchArray(MYSQL_NUM);
    $res->Free();

    // insert prefs row
    if ($rowCount < 1) {
      $db->Query("INSERT INTO `{pre}tccrn_plugin_settings` (`loglevel`) VALUES ('6')");
    }

    PutLog(sprintf('%s v%s installed', $this->name, $this->version), PRIO_PLUGIN, __FILE__, __LINE__);

    return true;
  }

  function Uninstall() {
    // log
    PutLog(sprintf('%s v%s uninstalled', $this->name, $this->version), PRIO_PLUGIN, __FILE__, __LINE__);
    return true;
  }

  function OnReadLang(&$lang_user, &$lang_client, &$lang_custom, &$lang_admin, $lang) {
    global $plugins;
    if (strpos($lang, 'deutsch') !== false) {
      $lang_admin['tccrn.angelegte_crons'] = 'Angelegte Aufgaben';
      $lang_admin['tccrn.keine_crons'] = 'Keine Aufgaben vorhanden';
      $lang_admin['tccrn.aktiviert'] = 'Aktiviert';
      $lang_admin['tccrn.aktivieren'] = 'Aktivieren!';
      $lang_admin['tccrn.deaktivieren'] = 'Deaktivieren!';
      $lang_admin['tccrn.cron'] = 'Aufgabe';
      $lang_admin['tccrn.naechster_aufruf'] = 'N&auml;chster Aufruf';
      $lang_admin['tccrn.status'] = 'Status';
      $lang_admin['tccrn.letzter_aufruf'] = 'Letzter Aufruf';
      $lang_admin['tccrn.cron_gestartet'] = 'Die Aufgabe wird evt. gerade durchgef&uuml;hrt...';
      $lang_admin['tccrn.cron_fehler'] = 'Die Aufgabe wurde nicht erfolgreich abgeschlossen.';
      $lang_admin['tccrn.cron_ok'] = 'Die Aufgabe wurde erfolgreich beendet.';
      $lang_admin['tccrn.serverzeit'] = 'Serverzeit';

      $lang_admin['tccrn.cron_fehler_hinweis'] = '%u Aufgabe(n) wurden nicht korrekt durchgef&uuml;hrt.';

      $lang_admin['tccrn.zeit'] = 'Zeit';
      $lang_admin['tccrn.monatstage'] = 'Monats-Tage';
      $lang_admin['tccrn.wochentage'] = 'Wochen-Tage';
      $lang_admin['tccrn.wochentage_array'] = array('Montag',
        'Dienstag',
        'Mittwoch',
        'Donnerstag',
        'Freitag',
        'Samstag',
        'Sonntag');
      $lang_admin['tccrn.monate'] = 'Monate';
      $lang_admin['tccrn.stunden'] = 'Stunden';
      $lang_admin['tccrn.minuten'] = 'Minuten';

      $lang_admin['tccrn.eta'] = 'In ';
      $lang_admin['tccrn.days'] = 'Tagen';
      $lang_admin['tccrn.hours'] = 'Stunden';
      $lang_admin['tccrn.minutes'] = 'Minuten';
      $lang_admin['tccrn.seconds'] = 'Sekunden';
      $lang_admin['tccrn.1days'] = 'einem Tag';
      $lang_admin['tccrn.1hours'] = 'einer Stunde';
      $lang_admin['tccrn.1minutes'] = 'einer Minute';
      $lang_admin['tccrn.1seconds'] = 'einer Sekunde';

      $lang_admin['tccrn.user_wirklich_loeschen'] = 'Benutzer unwiderruflich l&ouml;schen';
      $lang_admin['tccrn.benutzer_anwenden'] = 'Nur Benutzer, die...';
      $lang_admin['tccrn.nach_gruppe'] = 'Nach';

      $lang_admin['tccrn.trash_desc'] = 'Alle E-Mails aus Papierk&ouml;rben von Benutzern l&ouml;schen, die...';

      $lang_admin['tccrn.spam_desc'] = 'Alle E-Mails aus dem Spam-Ordner von Benutzern l&ouml;schen, die...';

      $lang_admin['tccrn.log_behalte'] = 'Behalte die letzten';

      //Aufgaben
      $lang_admin['tccrn.db_optimize'] = 'Datenbank optimieren';
      $lang_admin['tccrn.db_repair'] = 'Datenbank reparieren';
      $lang_admin['tccrn.db_struct'] = 'Datenbankstruktur reparieren';
      $lang_admin['tccrn.fs_cleanup'] = 'Tempor&auml;re Dateien aufr&auml;umen';
      $lang_admin['tccrn.cc_cleanup'] = 'Cache leeren';
      $lang_admin['tccrn.us_lock'] = 'Inaktive Benutzer sperren';
      $lang_admin['tccrn.us_move'] = 'Inaktive Benutzer in Gruppe verschieben';
      $lang_admin['tccrn.us_delete'] = 'Inaktive Benutzer l&ouml;schen';
      $lang_admin['tccrn.us_na_delete'] = 'Nicht aktivierte Benutzer l&ouml;schen';
      $lang_admin['tccrn.us_nl_delete'] = 'Benutzer ohne Logins l&ouml;schen';
      $lang_admin['tccrn.tr_delete'] = 'Papierkorb leeren';
      $lang_admin['tccrn.tr_sp_delete'] = 'Spamordner leeren';
      $lang_admin['tccrn.lg_archive'] = 'Logs archivieren';
      $lang_admin['tccrn.se_delete'] = 'Sessions l&ouml;schen';
      $lang_admin['tccrn.st_reset'] = 'Statistiken zur&uuml;cksetzen';
      $lang_admin['tccrn.op_delete'] = 'Waisen l&ouml;schen';

      if (isset($plugins->_plugins['B1GMailServerAdmin'])) {
        $lang_admin['tccrn.lg_bs_archive'] = 'Logs archivieren (b1gMailServer)';
        $lang_admin['tccrn.st_bs_reset'] = 'Statistiken zur&uuml;cksetzen (b1gMailServer)';
      }

      //Einstellungen
      $lang_admin['tccrn.logging'] = 'Logging';
      $lang_admin['tccrn.logging_debug'] = 'Debug-Meldungen loggen';
      $lang_admin['tccrn.logging_notices'] = 'Hinweise loggen';
      $lang_admin['tccrn.logging_warnings'] = 'Warnungen loggen';
      $lang_admin['tccrn.logging_errors'] = 'Fehler loggen';
    } else {
      $lang_admin['tccrn.angelegte_crons'] = 'Existing tasks';
      $lang_admin['tccrn.keine_crons'] = 'No existing tasks';
      $lang_admin['tccrn.aktiviert'] = 'Enabled';
      $lang_admin['tccrn.aktivieren'] = 'Enable!';
      $lang_admin['tccrn.deaktivieren'] = 'Disable!';
      $lang_admin['tccrn.cron'] = 'Task';
      $lang_admin['tccrn.naechster_aufruf'] = 'Next call';
      $lang_admin['tccrn.status'] = 'Status';
      $lang_admin['tccrn.letzter_aufruf'] = 'Last called';
      $lang_admin['tccrn.cron_gestartet'] = 'The task might being processed right now...';
      $lang_admin['tccrn.cron_fehler'] = 'The task was not completed successfully.';
      $lang_admin['tccrn.cron_ok'] = 'The task was completed successfully.';
      $lang_admin['tccrn.serverzeit'] = 'Servertime';

      $lang_admin['tccrn.cron_fehler_hinweis'] = '%u task(s) were not completed successfully.';

      $lang_admin['tccrn.zeit'] = 'Time';
      $lang_admin['tccrn.monatstage'] = 'Days of the month';
      $lang_admin['tccrn.wochentage'] = 'Days of the week';
      $lang_admin['tccrn.wochentage_array'] = array('Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday');
      $lang_admin['tccrn.monate'] = 'Months';
      $lang_admin['tccrn.stunden'] = 'Hours';
      $lang_admin['tccrn.minuten'] = 'Minutes';

      $lang_admin['tccrn.eta'] = 'In ';
      $lang_admin['tccrn.days'] = 'days';
      $lang_admin['tccrn.hours'] = 'hours';
      $lang_admin['tccrn.minutes'] = 'minutes';
      $lang_admin['tccrn.seconds'] = 'seconds';
      $lang_admin['tccrn.1days'] = 'one day';
      $lang_admin['tccrn.1hours'] = 'one hour';
      $lang_admin['tccrn.1minutes'] = 'one minute';
      $lang_admin['tccrn.1seconds'] = 'one second';

      $lang_admin['tccrn.user_wirklich_loeschen'] = 'Delete users (non-revocable)';
      $lang_admin['tccrn.benutzer_anwenden'] = 'Only users, that...';
      $lang_admin['tccrn.nach_gruppe'] = 'To';

      $lang_admin['tccrn.trash_desc'] = 'Empty all trashes from users, that...';

      $lang_admin['tccrn.spam_desc'] = 'Empty all spam folders from users, that...';

      $lang_admin['tccrn.log_behalte'] = 'Keep the last';

      //Aufgaben
      $lang_admin['tccrn.db_optimize'] = 'Database: Optimize';
      $lang_admin['tccrn.db_repair'] = 'Database: Repair';
      $lang_admin['tccrn.db_struct'] = 'Database: Repair structure';
      $lang_admin['tccrn.fs_cleanup'] = 'Clean up temporary files';
      $lang_admin['tccrn.cc_cleanup'] = 'Empty cache';
      $lang_admin['tccrn.us_lock'] = 'Inactive users: Block';
      $lang_admin['tccrn.us_move'] = 'Inactive users: Move to group';
      $lang_admin['tccrn.us_delete'] = 'Inactive users: Delete';
      $lang_admin['tccrn.us_na_delete'] = 'Not activated users: Delete';
      $lang_admin['tccrn.us_nl_delete'] = 'Users without logins: Delete';
      $lang_admin['tccrn.tr_delete'] = 'Empty trash';
      $lang_admin['tccrn.tr_sp_delete'] = 'Empty spam folder';
      $lang_admin['tccrn.lg_archive'] = 'Archive logs';
      $lang_admin['tccrn.se_delete'] = 'Destroy sessions';
      $lang_admin['tccrn.st_reset'] = 'Reset statistics';
      $lang_admin['tccrn.op_delete'] = 'Delete orphans';

      if (isset($plugins->_plugins['B1GMailServerAdmin'])) {
        $lang_admin['tccrn.lg_bs_archive'] = 'Archive logs (b1gMailServer)';
        $lang_admin['tccrn.st_bs_reset'] = 'Reset statistics (b1gMailServer)';
      }

      //Einstellungen
      $lang_admin['tccrn.logging'] = 'Logging';
      $lang_admin['tccrn.logging_debug'] = 'Log debug messages';
      $lang_admin['tccrn.logging_notices'] = 'Log notices';
      $lang_admin['tccrn.logging_warnings'] = 'Log warnings';
      $lang_admin['tccrn.logging_errors'] = 'Log errors';
    }
  }

  function AdminHandler() {
    global $tpl, $lang_admin;

    $tpl->register_function('tccrn_countdown', 'TCCRNTemplateCountdown');

    if (!isset($_REQUEST['action']))
      $_REQUEST['action'] = 'start';

    $tabs = array(
      0 => array('title' => $lang_admin['overview'],
        'link' => $this->_adminLink() . '&amp;',
        'relIcon' => 'info32.png',
        'active' => $_REQUEST['action'] == 'start'),
      1 => array('title' => $lang_admin['tccrn.cron'],
        'link' => $this->_adminLink() . '&amp;action=task&amp;',
        'icon' => '../plugins/templates/images/tccrn_task.png',
        'active' => $_REQUEST['action'] == 'task'),
      2 => array('title' => $lang_admin['prefs'],
        'link' => $this->_adminLink() . '&amp;action=settings&amp;',
        'relIcon' => 'ico_prefs_common.png',
        'active' => $_REQUEST['action'] == 'settings'));

    $tpl->assign('tabs', $tabs);
    switch ($_REQUEST['action']) {
      case 'settings':
        $this->_adminSettings();
        break;
      case 'task':
        $this->_adminTask();
        break;
      default:
        $this->_adminStart();
    }
    $tpl->assign('pageURL', $this->_adminLink());
    $tpl->assign('tccrn_name', $this->name);
  }

  var $_config = null;

  function _getConfig() {
    global $db;
    if ($this->_config == null) {
      $res = $db->Query('SELECT * FROM {pre}tccrn_plugin_settings LIMIT 1');
      $config = $res->FetchArray();
      $res->Free();
      $this->_config = $config;
    }
    return $this->_config;
  }

  function _adminSettings() {
    global $tpl, $db;
    if (strtolower($_SERVER['REQUEST_METHOD']) == 'post') {
      $logLevel = 0;
      if (isset($_REQUEST['loglevel']) && is_array($_REQUEST['loglevel'])) {
        foreach ($_REQUEST['loglevel'] as $val) {
          $logLevel |= $val;
        }
      }
      $db->Query('UPDATE {pre}tccrn_plugin_settings SET loglevel = ?', $logLevel);
      $this->_config = null;
    }
    $tpl->assign('page', $this->_templatePath('tccrn.admin.settings.tpl'));
    $tpl->assign('tccrn_prefs', $this->_getConfig());
  }

  function _taskDb($op, $tables) {
    global $db;
    foreach ($tables as $table) {
      $db->Query($op . $table);
    }
  }

  function _task_db_optimize($taskData) {
    $this->_taskDb('OPTIMIZE TABLE ', $taskData['table']);
  }

  function _task_db_repair($taskData) {
    $this->_taskDb('REPAIR TABLE ', $taskData['table']);
  }

  function _task_db_struct($taskData) {
    // read default structure
    $databaseStructure = '';
    include (B1GMAIL_DIR . '/serverlib/database.struct.php');
    $databaseStructure = unserialize(base64_decode($databaseStructure));
    $myDatabaseStructure = array();
    foreach ($databaseStructure as $table => $value) {
      if (array_search($table, $taskData['table']) !== false) {
        $myDatabaseStructure[$table] = $value;
      }
    }
    SyncDBStruct($myDatabaseStructure);
  }

  function _task_fs_cleanup($taskData, $log) {
    CleanupTempFiles();
    if ($log) {
      PutLog('Cleaned up temp files.', PRIO_NOTE, __FILE__, __LINE__);
    }
  }

  function _task_cc_cleanup($taskData, $log) {
    global $bm_prefs, $cacheManager;
    if ($bm_prefs['cache_type'] == CACHE_B1GMAIL || $bm_prefs['cache_type'] == CACHE_MEMCACHE) {
      $cacheManager->CleanUp(true);
    }
    if ($log) {
      PutLog('Cleaned up cache.', PRIO_NOTE, __FILE__, __LINE__);
    }
  }

  function _taskUsCondition($taskData) {
    $condition = array();
    if (empty($taskData['groups'])) {
      return 'WHERE 0 = 1';
    }
    $timeDiff = time() - max(1, $taskData['days']) * TIME_ONE_DAY;
    $condition[] = sprintf('(lastlogin<%d AND last_notify<%d AND last_pop3<%d AND last_imap<%d AND reg_date<%d)', $timeDiff, $timeDiff, $timeDiff, $timeDiff, $timeDiff);
    $condition[] = '(gruppe IN (' . implode(',', array_values($taskData['groups'])) . '))';
    $condition = 'WHERE ' . implode(' AND ', $condition);
    return $condition;
  }

  function _task_us_lock($taskData, $log) {
    global $db;
    $condition = $this->_taskUsCondition($taskData);
    $db->Query('UPDATE {pre}users SET gesperrt=? ' . $condition, 'yes');
    if ($log) {
      PutLog('Locked inactive users from group(s) ' . implode(',', array_values($taskData['groups'])) . ': ' . $db->AffectedRows(), PRIO_NOTE, __FILE__, __LINE__);
    }
  }

  function _task_us_move($taskData, $log) {
    global $db;
    $condition = $this->_taskUsCondition($taskData);
    $db->Query('UPDATE {pre}users SET gruppe=? ' . $condition, $taskData['moveGroup']);
    if ($log) {
      PutLog('Moved inactive users from group(s) ' . implode(',', array_values($taskData['groups'])) . ' to group ' . $taskData['moveGroup'] . ': ' . $db->AffectedRows(), PRIO_NOTE, __FILE__, __LINE__);
    }
  }

  function _task_us_delete($taskData, $log, $mode = false) {
    global $db;
    $condition = $this->_taskUsCondition($taskData);
    if($mode == 'delete_not_active') {
      $condition .= ' AND gesperrt = "locked"';
    } else if($mode == 'delete_no_login') {
      $condition .= ' AND lastlogin = 0 AND last_pop3 = 0 AND last_imap = 0';
    }
    $adjective = ($mode ? substr($mode, 7) : 'inactive');
    if(!empty($taskData['realdel'])) {
      $res = $db->Query('SELECT `id` FROM {pre}users ' . $condition);
      $i = 0;
      while (($row = $res->FetchArray(MYSQL_NUM)) != false) {
        $i++;
        DeleteUser($row[0]);
      }
      if ($log) {
        PutLog('Deleted ' . $adjective . ' users from group(s) ' . implode(',', array_values($taskData['groups'])) . ': ' . $i, PRIO_NOTE, __FILE__, __LINE__);
      }
    } else {
      $db->Query('UPDATE {pre}users SET gesperrt=? ' . $condition, 'delete');
      if ($log) {
        PutLog('Marked ' . $adjective . ' users for deletion from group(s) ' . implode(',', array_values($taskData['groups'])) . ': ' . $db->AffectedRows(), PRIO_NOTE, __FILE__, __LINE__);
      }
    }
  }

  function _task_us_na_delete($taskData, $log) {
    $this->_task_us_delete($taskData, $log, 'delete_not_active');
  }

  function _task_us_nl_delete($taskData, $log) {
    $this->_task_us_delete($taskData, $log, 'delete_no_login');
  }

  function _task_tr_delete($taskData, $log, $spamFolder = false) {
    global $db;
    // load class, if needed
    if(!class_exists('BMMailbox'))
      include(B1GMAIL_DIR . 'serverlib/mailbox.class.php');
    if(!class_exists('BMUser'))
      include(B1GMAIL_DIR . 'serverlib/user.class.php');
    $mails = $mailSizes = 0;
    $res = $db->Query('SELECT id,email FROM {pre}users WHERE gruppe IN(' . implode(',', array_values($taskData['groups'])) . ')');
    while (($row = $res->FetchArray(MYSQL_ASSOC)) !== false) {
      $user = _new('BMUser', array($row['id']));
      /* @var $mailbox BMMailbox */
      $mailbox = _new('BMMailbox', array($row['id'],
        $row['email'],
        $user));

      if($spamFolder) {
        $trashMails = $mailbox->GetMailList(FOLDER_SPAM);
      } else {
        $trashMails = $mailbox->GetMailList(FOLDER_TRASH);
      }
      foreach ($trashMails as $mailID => $mail) {
        if ((!isset($taskData['daysOnly']) || $mail['timestamp'] < time() - max(1, $taskData['days']) * TIME_ONE_DAY) && (!isset($taskData['sizesOnly']) || $mail['size'] > max(1, $taskData['size']) * 1024)) {
          // delete
          $mailbox->DeleteMail($mailID);

          // stats
          $mails++;
          $mailSizes += $mail['size'];
        }
      }
      unset($mailbox);
      unset($user);
    }
    if ($log) {
      PutLog('Cleaned up ' . ($spamFolder ? 'spam folders' : 'trashes') . '; Deleted ' . $mails . ' mails (' . round($mailSizes / 1024 / 1024, 2) . ' MB)', PRIO_NOTE, __FILE__, __LINE__);
    }
    $res->Free();
  }

  function _task_tr_sp_delete($taskData, $log) {
    $this->_task_tr_delete($taskData, $log, true);
  }

  function _taskOpenLogfile($fileName) {
    if (PHPNumVersion() >= 430 && function_exists('gzopen')) {
      $fp = fopen('compress.bzip2://' . $fileName . '.bz2', 'w+');
    }
    if (!isset($fp) || !$fp) {
      $fp = fopen($fileName, 'w+');
    }
    return $fp;
  }

  function _task_lg_archive($taskData, $log) {
    global $db;
    $date = time();
    if (isset($taskData['keepDays']) && isset($taskData['days'])) {
      $date -= TIME_ONE_DAY * $taskData['days'];
    }
    if ($log) {
      PutLog('Archiving log entries before ' . date('r', $date), PRIO_NOTE, __FILE__, __LINE__);
    }
    if(function_exists('ArchiveLogs')) {
      PutLog('Seems to be an up to date version of b1gMail: will use ArchiveLogs()', PRIO_DEBUG, __FILE__, __LINE__);
      $archive = !empty($taskData['save']);
      $archivedLogEntryCount = -1;
      if(!ArchiveLogs($date, $archive, $archivedLogEntryCount)) {
        PutLog('Failed to create a new log archive file. The archiving procedure has been aborted.', PRIO_ERROR, __FILE__, __LINE__);
      } else {
        if($log) {
          PutLog('Archived ' . $archivedLogEntryCount . ' log entries', PRIO_NOTE, __FILE__, __LINE__);
        }
      }
    } else {
      PutLog('This is not an up to date version of b1gMail: will use my own mechanisms', PRIO_DEBUG, __FILE__, __LINE__);
      if (!empty($taskData['save'])) {
        $fileName = B1GMAIL_DIR . 'logs/b1gMailLog-' . time() . '.log';
        $fp = $this->_taskOpenLogfile($fileName);
        if (!$fp) {
          PutLog('Could not open ' . $fileName . ' for writing!', PRIO_ERROR, __FILE__, __LINE__);
          return;
        }
        fwrite($fp, '#' . "\n");
        fwrite($fp, '# b1gMail ' . B1GMAIL_VERSION . "\n");
        fwrite($fp, '# Log file' . "\n");
        fwrite($fp, '#' . "\n");
        fwrite($fp, '# To: ' . date('r', $date) . "\n");
        fwrite($fp, '# Generated: ' . date('r') . "\n");
        fwrite($fp, '#' . "\n");
        fwrite($fp, "\n");
        $res = $db->Query('SELECT prio,eintrag,zeitstempel FROM {pre}logs WHERE zeitstempel<' . $date . ' ORDER BY id ASC');
        while (($row = $res->FetchArray()) !== false) {
          fwrite($fp, sprintf('%s [%d]: %s' . "\n", date('r', $row['zeitstempel']), $row['prio'], $row['eintrag']));
        }
        if ($log) {
          PutLog('Exported ' . ((int) $res->RowCount()) . ' log entries to ' . $fileName, PRIO_NOTE, __FILE__, __LINE__);
        }
        $res->Free();
        fclose($fp);
      }
      $db->Query('DELETE FROM {pre}logs WHERE zeitstempel<' . $date);
    }
  }

  function _task_lg_bs_archive($taskData, $log) {
    global $db;
    $date = time();
    if (isset($taskData['keepDays']) && isset($taskData['days'])) {
      $date -= TIME_ONE_DAY * $taskData['days'];
    }
    if (!empty($taskData['save'])) {
      $fileName = B1GMAIL_DIR . 'logs/b1gMailServerLog-' . time() . '.log';
      $fp = $this->_taskOpenLogfile($fileName);
      if (!$fp) {
        PutLog('Could not open ' . $fileName . ' for writing!', PRIO_ERROR, __FILE__, __LINE__);
        return;
      }
      fwrite($fp, '#' . "\n");
      fwrite($fp, '# b1gMailServer ' . "\n");
      fwrite($fp, '# Log file' . "\n");
      fwrite($fp, '#' . "\n");
      fwrite($fp, '# To: ' . date('r', $date) . "\n");
      fwrite($fp, '# Generated: ' . date('r') . "\n");
      fwrite($fp, '#' . "\n");
      fwrite($fp, "\n");
      $res = $db->Query('SELECT iComponent,iSeverity,iDate,szEntry FROM {pre}bms_logs WHERE iDate<' . $date . ' ORDER BY id ASC');
      $componentNames = array(BMS_CMP_CORE => 'Core',
        BMS_CMP_HTTP => 'HTTP',
        BMS_CMP_IMAP => 'IMAP',
        BMS_CMP_MSGQUEUE => 'MSGQueue',
        BMS_CMP_POP3 => 'POP3',
        BMS_CMP_SMTP => 'SMTP');
      while (($row = $res->FetchArray(MYSQL_ASSOC)) !== false) {
        fwrite($fp, sprintf('[%s] %s [%d]: %s' . "\n", $componentNames[$row['iComponent']], date('r', $row['iDate']), $row['iSeverity'], trim($row['szEntry'])));
      }
      if ($log) {
        PutLog('Exported ' . ((int) $res->RowCount()) . ' log entries (b1gMailServer) to ' . $fileName, PRIO_NOTE, __FILE__, __LINE__);
      }
      $res->Free();
      fclose($fp);
    }
    if ($log) {
      PutLog('Deleting log entries (b1gMailServer) before ' . date('r', $date), PRIO_NOTE, __FILE__, __LINE__);
    }
    $db->Query('DELETE FROM {pre}bms_logs WHERE iDate<' . $date);
  }

  function _task_se_delete($taskData, $log) {
    $dir = B1GMAIL_DIR . 'temp/session/';
    $limit = time() - ($taskData['days'] * TIME_ONE_DAY);
    $deleted = 0;
    if (is_dir($dir)) {
      if (($dh = opendir($dir)) != false) {
        while (($file = readdir($dh)) !== false) {
          if (substr($file, 0, 5) != 'sess_') {
            continue;
          }
          $path = $dir . $file;
          if (fileatime($path) < $limit && filectime($path) < $limit && filemtime($path) < $limit) {
            if (@unlink($path)) {
              $deleted++;
            }
          }
        }
        closedir($dh);
      }
    }
    if ($log) {
      PutLog('Deleted ' . $deleted . ' session(s).', PRIO_NOTE, __FILE__, __LINE__);
    }
  }

  function _task_st_reset($taskData, $log) {
    global $db;
    if (empty($taskData) || empty($taskData['days'])) {
      $db->Query('TRUNCATE TABLE {pre}stats');
      if ($log) {
        PutLog('Statistics reseted', PRIO_NOTE, __FILE__, __LINE__);
      }
    } else {
      $limit = time() - ($taskData['days'] * TIME_ONE_DAY);
      $d = date('j', $limit);
      $m = date('n', $limit);
      $y = date('Y', $limit);
      $db->Query('DELETE FROM {pre}stats WHERE (d < ' . $d . ' AND m = ' . $m . ' AND y = ' . $y . ') OR (m < ' . $m . ' AND y = ' . $y . ') OR (y < ' . $y . ')');
      if ($log) {
        PutLog('Deleted statistic entries before ' . date('r', $limit), PRIO_NOTE, __FILE__, __LINE__);
      }
    }
  }

  function _task_st_bs_reset($taskData, $log) {
    global $db;
    if (empty($taskData) || empty($taskData['days'])) {
      $db->Query('TRUNCATE TABLE {pre}bms_sessions');
      if ($log) {
        PutLog('b1gMailServer statistics reseted', PRIO_NOTE, __FILE__, __LINE__);
      }
    } else {
      $limit = time() - ($taskData['days'] * TIME_ONE_DAY);
      $db->Query('DELETE FROM {pre}bms_sessions WHERE iDate < ' . $limit);
      if ($log) {
        PutLog('Deleted b1gMailServer statistic entries before ' . date('r', $limit), PRIO_NOTE, __FILE__, __LINE__);
      }
    }
  }

  function _task_op_delete($taskData, $log) {
    global $db;
    $deletedCount = $deletedSize = 0;
    $res = $db->Query('SELECT `id`,`size`,`body` FROM {pre}mails WHERE `userid` NOT IN(SELECT `id` FROM {pre}users)');
    while(($row = $res->FetchArray(MYSQL_ASSOC)) != false) {
      if($row['body'] == 'file') {
        $fileName = DataFilename($row['id']);
        if(file_exists($fileName)) {
          @unlink($fileName);
        }
      }
      $db->Query('DELETE FROM {pre}mails WHERE `id`=?', $row['id']);
      $db->Query('DELETE FROM {pre}attachments WHERE `mailid`=?', $row['id']);
      $deletedCount++;
      $deletedSize += $row['size'];
    }
    if($log) {
      PutLog(sprintf('%d orphaned email(s) have been found and deleted (%.02f KB)', $deletedCount, $deletedSize/1024), PRIO_NOTE, __FILE__, __LINE__);
    }
    $res->Free();
  }

  function _executeTask($task, $force = false) {
    global $db;
    $config = $this->_getConfig();
    $task['taskdata'] = unserialize($task['taskdata']);
    $task['crondata'] = unserialize($task['crondata']);
    if ($task['active']) {
      $start = microtime(true);
      if (($config['loglevel'] & 8) != 0) {
        PutLog('Executing cron ' . $task['cronid'] . ': Task = ' . $task['task'] . '; Nextcall = ' . date('r', $task['nextcall']) . '; Lastcall = ' . date('r', $task['lastcall']) . '; Status = ' . $task['status'], PRIO_DEBUG, __FILE__, __LINE__);
      }
      if (!$force && $task['status'] == 'started') {
        if($task['lastcall'] + 60 < time()) {
          if(($config['loglevel'] & 4) != 0) {
            PutLog('Cron ' . $task['cronid'] . ' (' . $task['task'] . ') didn\'t finish correctly... Lastcall = ' . date('r', $task['lastcall']), PRIO_ERROR, __FILE__, __LINE__);
          }
        } else {
          return;
        }
      }
      if ($task['nextcall'] && (($delay = time() - $task['nextcall']) > 600) && ($config['loglevel'] & 2) != 0) {
        PutLog('Cron ' . $task['cronid'] . ' (' . $task['task'] . ') executed with a delay of ' . $delay . 's...', PRIO_WARNING, __FILE__, __LINE__);
      }
      $db->Query('UPDATE {pre}tccrn_plugin_cron SET status = ?, lastcall = ? WHERE cronid = ?', 'started', time(), $task['cronid']);
      $f = '_task_' . substr($task['task'], 6);
      $this->$f($task['taskdata'], $task['log']);
      $time = microtime(true) - $start;
      if ($time > 20 && ($config['loglevel'] & 2) != 0) {
        PutLog('Executing cron ' . $task['cronid'] . ' (' . $task['task'] . ') took a long time (' . $time . 's)!', PRIO_WARNING, __FILE__, __LINE__);
      } elseif ($time > 5 && ($config['loglevel'] & 1) != 0) {
        PutLog('Executing cron ' . $task['cronid'] . ' (' . $task['task'] . ') took a long time (' . $time . 's)!', PRIO_NOTE, __FILE__, __LINE__);
      } elseif (($config['loglevel'] & 8) != 0) {
        PutLog('Executing cron ' . $task['cronid'] . ' (' . $task['task'] . ') took ' . $time . 's.');
      }
    }
    $db->Query('UPDATE {pre}tccrn_plugin_cron SET status = ?, nextcall = ? WHERE cronid = ?', 'finished', $this->_getNextCall($task['crondata']), $task['cronid']);
  }

  function OnCron() {
    global $db;
    $config = $this->_getConfig();
    $res = $db->Query('SELECT * FROM {pre}tccrn_plugin_cron WHERE nextcall <= ? AND nextcall != 0 AND active = 1 ORDER BY RAND() LIMIT 5', time());
    if (($c = $res->RowCount()) != 0) {
      if (($config['loglevel'] & 8) != 0) {
        PutLog($c . ' cron(s) found...', PRIO_DEBUG, __FILE__, __LINE__);
      }
    }
    while (($task = $res->FetchArray()) !== false) {
      $this->_executeTask($task);
    }
    if ($c && ($config['loglevel'] & 8) != 0) {
      PutLog('All done!', PRIO_DEBUG, __FILE__, __LINE__);
    }
    $res->Free();

    $res = $db->Query('SELECT cronid, crondata FROM {pre}tccrn_plugin_cron WHERE nextcall <= ? AND nextcall != 0 AND active = 0', time());
    while (($task = $res->FetchArray()) !== false) {
      $db->Query('UPDATE {pre}tccrn_plugin_cron SET status = ?, nextcall = ? WHERE cronid = ?', 'finished', $this->_getNextCall($task['crondata']), $task['cronid']);
    }
    $res->Free();
  }

  function getNotices() {
    global $db, $lang_admin;
    $res = $db->Query('SELECT COUNT(*) FROM {pre}tccrn_plugin_cron WHERE status = ? AND lastcall < ?', 'started', time() - 30);
    $count = $res->FetchArray(MYSQL_NUM);
    $res->Free();
    $count = $count[0];
    if ($count > 0) {
      return array(
        array('type' => 'error',
          'text' => $this->name . ': ' . sprintf($lang_admin['tccrn.cron_fehler_hinweis'], $count),
          'link' => $this->_adminLink() . '&amp;'));
    } else {
      return array();
    }
  }

  function _adminStart() {
    global $tpl, $db;
    if (isset($_GET['do'])) {
      if ($_GET['do'] == 'delete') {
        $db->Query('DELETE FROM {pre}tccrn_plugin_cron WHERE cronid = ?', $_GET['id']);
      } elseif ($_GET['do'] == 'switch') {
        $res = $db->Query('SELECT crondata FROM {pre}tccrn_plugin_cron WHERE cronid = ?', $_GET['id']);
        if ($res->RowCount()) {
          list ($crondata) = $res->FetchArray(MYSQL_NUM);
          $crondata = unserialize($crondata);
          $db->Query('UPDATE {pre}tccrn_plugin_cron SET active = ?, nextcall = ? WHERE cronid = ?', $_GET['active'] == 1 ? 0 : 1, $_GET['active'] == 1 ? 0 : $this->_getNextCall($crondata), $_GET['id']);
        }
        $res->Free();
      } elseif ($_GET['do'] == 'execute') {
        $res = $db->Query('SELECT * FROM {pre}tccrn_plugin_cron WHERE cronid = ?', $_GET['id']);
        if ($res->RowCount()) {
          $task = $res->FetchArray();
          $this->_executeTask($task, true);
        }
        $res->Free();
      }
    }
    global $currentLanguage;
    $queryURL = sprintf('%s?action=getLatestVersion&internalName=%s&b1gMailVersion=%s&js=1&language=%s&version=%s',
      $this->update_url,
      urlencode($this->internal_name),
      urlencode(B1GMAIL_VERSION),
      $currentLanguage,
      $this->version);
    $tpl->assign('updateURL', $queryURL);
    $tpl->assign('notices', $this->getNotices());

    $tpl->assign('page', $this->_templatePath('tccrn.admin.start.tpl'));
    $tpl->assign('groups', BMGroup::GetSimpleGroupList());
    $tpl->assign('tccrn_tasks', $this->_getTasks());
  }

  function _getTasks() {
    global $db;
    $res = $db->Query('SELECT cronid, task, nextcall, taskdata, status, active, lastcall FROM {pre}tccrn_plugin_cron ORDER BY active DESC, nextcall ASC');
    $tasks = array();
    while (($task = $res->FetchArray()) !== false) {
      $task['taskdata'] = unserialize($task['taskdata']);
      $tasks[$task['cronid']] = $task;
    }
    return $tasks;
  }

  var $_taskData = array('db_optimize' => 'db',
    'db_repair' => 'db',
    'db_struct' => 'db',
    'us_lock' => 'user',
    'us_move' => 'userGroup',
    'us_delete' => 'user',
    'us_na_delete' => 'user',
    'us_nl_delete' => 'user',
    'tr_delete' => 'trash',
    'tr_sp_delete' => 'trash',
    'lg_archive' => 'log',
    'lg_bs_archive' => 'log',
    'se_delete' => 'session',
    'st_reset' => 'stats',
    'st_bs_reset' => 'stats');

  function _loadTaskData($task) {
    global $db, $mysql, $tpl;
    $task = substr($task, 6);
    if (isset($this->_taskData[$task])) {
      if (substr($task, 0, 2) == 'db') {
        $res = $db->Query('SHOW TABLES');
        $myTables = array();
        while (($row = $res->FetchArray(MYSQL_NUM)) !== false) {
          if (substr($row[0], 0, strlen($mysql['prefix'])) == $mysql['prefix']) {
            $myTables[] = $row[0];
          }
        }
        $res->Free();
        $tpl->assign('tccrn_tables', $myTables);
      } elseif (substr($task, 0, 2) == 'us') {
        $tpl->assign('groups', BMGroup::GetSimpleGroupList());
      } elseif (substr($task, 0, 2) == 'tr') {
        $tpl->assign('groups', BMGroup::GetSimpleGroupList());
      }
      $tpl->assign('tccrn_task_data', $this->_templatePath('tccrn.admin.taskdata.' . $this->_taskData[$task] . '.tpl'));
    }
  }

  function _adminRedirect() {
    header('Location: ' . $this->_adminLink(true));
    exit();
  }

  function _getNextCall($cronData) {
    if(!isset($cronData['month']) || !isset($cronData['day']) || !isset($cronData['weekday']) || !isset($cronData['hour']) || !isset($cronData['minute'])) {
      return 0;
    }
    $aYear = date('y');
    $nTime = 0;
    $time = time();
    for ($year = $aYear; $year <= $aYear + 10; $year++) {
      for ($month = 1; $month <= 12; $month++) {
        if (mktime(23, 59, 59, $month, 31, $year) < $time || array_search($month, $cronData['month']) === false) {
          continue;
        }
        for ($day = 1; $day <= 31; $day++) {
          if (mktime(23, 59, 59, $month, $day, $year) < $time || array_search($day, $cronData['day']) === false) {
            continue;
          }
          $w = date('w', mktime(0, 0, 0, $month, $day, $year));
          if ($w == 0) {
            $w = 7;
          }
          --$w;
          if (array_search($w, $cronData['weekday']) === false) {
            continue;
          }
          for ($hour = 0; $hour <= 23; $hour++) {
            if (mktime($hour, 59, 59, $month, $day, $year) < $time || array_search($hour, $cronData['hour']) === false) {
              continue;
            }
            for ($minute = 0; $minute <= 59; $minute++) {
              if (mktime($hour, $minute, 0, $month, $day, $year) <= $time || array_search($minute, $cronData['minute']) === false) {
                continue;
              }
              $nTime = mktime($hour, $minute, 0, $month, $day, $year);
              break (5);
            }
          }
        }
      }
    }
    return $nTime;
  }

  function _adminTask() {
    global $tpl, $lang_admin, $db;
    $tasks = array();
    foreach ($lang_admin as $k => $v) {
      if (substr($k, 0, 6) == 'tccrn.' && $k[8] == '_') {
        $tasks[$k] = $v;
      }
    }
    asort($tasks);

    if (strtolower($_SERVER['REQUEST_METHOD']) == 'post') {
      if (!isset($tasks[$_POST['task']])) {
        $ks = array_keys($tasks);
        $_POST['task'] = $ks[0];
      }
      if (!empty($_POST['next'])) {
        $tpl->assign('tccrn_data', $_POST);
        $this->_loadTaskData($_POST['task']);
      } else {
        if (empty($_POST['taskdata'])) {
          $_POST['taskdata'] = array();
        }
        if (empty($_POST['crondata'])) {
          $_POST['crondata'] = array();
        }
        $id = isset($_POST['id']) ? (int) $_POST['id'] : 'NULL';
        if (!empty($_POST['active'])) {
          $nextCall = $this->_getNextCall($_POST['crondata']);
        } else {
          $nextCall = 0;
        }
        $db->Query('REPLACE INTO {pre}tccrn_plugin_cron(cronid, active, log, task, nextcall, crondata, taskdata) VALUES (' . $id . ', ?, ?, ?, ?, ?, ?)', !empty($_POST['active']), !empty($_POST['log']), $_POST['task'], $nextCall, serialize($_POST['crondata']), serialize($_POST['taskdata']));
        $this->_adminRedirect();
      }
    } elseif (isset($_GET['id'])) {
      $res = $db->Query('SELECT * FROM {pre}tccrn_plugin_cron WHERE cronid = ?', $_GET['id']);
      $row = $res->FetchArray();
      $row['taskdata'] = unserialize($row['taskdata']);
      $row['crondata'] = unserialize($row['crondata']);
      $tpl->assign('tccrn_data', $row);
      $this->_loadTaskData($row['task']);
    }

    $tpl->assign('tccrn_tasks', $tasks);
    $tpl->assign('tccrn_wochentage_array', $lang_admin['tccrn.wochentage_array']);
    $tpl->assign('page', $this->_templatePath('tccrn.admin.task.tpl'));
  }
}
/**
 * register plugin
 */
$plugins->registerPlugin('TCCronPlugin');

function TCCRNTemplateCountdown($params, &$smarty) {
  global $lang_admin;

  $newDate = $params['timestamp'];
  $actDate = time();
  $diffDate = ($newDate - $actDate);
  if ($actDate >= $newDate) {
    return $lang_admin['now'] . '...';
  } elseif ($actDate + 60 > $newDate) {
    return $lang_admin['tccrn.eta'] . $diffDate . ' ' . $lang_admin['tccrn.seconds'];
  }

  $days = floor($diffDate / 24 / 60 / 60);
  $diffDate = $diffDate - ($days * 24 * 60 * 60);
  $hours = floor($diffDate / 60 / 60);
  $diffDate = ($diffDate - ($hours * 60 * 60));
  $minutes = floor($diffDate / 60);

  $string = $lang_admin['tccrn.eta'];
  $res = array('days' => $days, 'hours' => $hours, 'minutes' => $minutes);
  foreach (array_keys($res) as $var) {
    if ($$var == 0) {
      unset($res[$var]);
    }
  }
  $i = count($res);
  foreach ($res as $k => $v) {
    --$i;
    if ($v == 1) {
      $string .= $lang_admin['tccrn.1' . $k];
    } else {
      $string .= $v . ' ' . $lang_admin['tccrn.' . $k];
    }
    if ($i != 0) {
      $string .= ', ';
    }
  }

  return $string;
}

?>
