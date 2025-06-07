<?php
/**
 * BetterQuota
 *
 * @link     http://www.thinkclever.ch/
 * @copyright  2007-2013 ThinkClever IT Solutions
 */

/**
 * BetterQuota
 *
 */
class TCSpacePlugin extends BMPlugin {

  function TCSpacePlugin() {
    $this->name = 'BetterQuota';
    $this->author = 'ThinkClever GmbH';
    $this->web = 'http://www.thinkclever.ch/';
    $this->mail = 'info@thinkclever.ch';
    $this->version = '1.2.0';
    $this->designedfor = '7.3.0';
    $this->type = BMPLUGIN_DEFAULT;

    $this->admin_pages = false;

    $this->website = 'http://my.b1gmail.com/details/43/';
    $this->update_url = 'http://code.thinkclever.net/b1gmail/plugins/update/index.php/-' . md5(B1GMAIL_LICNR . md5(B1GMAIL_SIGNKEY)) . '-/';
  }

  function Install() {
    global $mysql, $db;
    $databaseStructure =
        'YToxOntzOjIyOiJ7cHJlfXRjc3BjX3BsdWdpbl91c2VyIjthOjI6e3M6NjoiZmllbGRzIjthOjQ'
      . '6e2k6MDthOjY6e2k6MDtzOjY6InVzZXJpZCI7aToxO3M6MTY6ImludCgxMSkgdW5zaWduZWQiO2'
      . 'k6MjtzOjI6Ik5PIjtpOjM7czozOiJQUkkiO2k6NDtOO2k6NTtzOjA6IiI7fWk6MTthOjY6e2k6M'
      . 'DtzOjQ6Im1haWwiO2k6MTtzOjE5OiJiaWdpbnQoMjApIHVuc2lnbmVkIjtpOjI7czoyOiJOTyI7'
      . 'aTozO3M6MDoiIjtpOjQ7TjtpOjU7czowOiIiO31pOjI7YTo2OntpOjA7czo3OiJ3ZWJkaXNrIjt'
      . 'pOjE7czoxOToiYmlnaW50KDIwKSB1bnNpZ25lZCI7aToyO3M6MjoiTk8iO2k6MztzOjA6IiI7aT'
      . 'o0O047aTo1O3M6MDoiIjt9aTozO2E6Njp7aTowO3M6MTE6ImF1dG9tYXRpc2NoIjtpOjE7czoxO'
      . 'ToidGlueWludCgxKSB1bnNpZ25lZCI7aToyO3M6MjoiTk8iO2k6MztzOjA6IiI7aTo0O047aTo1'
      . 'O3M6MDoiIjt9fXM6NzoiaW5kZXhlcyI7YToxOntzOjc6IlBSSU1BUlkiO2E6MTp7aTowO3M6Njo'
      . 'idXNlcmlkIjt9fX19';
    $databaseStructure = unserialize(base64_decode($databaseStructure));
    $structure = array();
    foreach($databaseStructure as $tableName => $data) {
      $tableName = str_replace('{pre}', $mysql['prefix'], $tableName);
      $structure[$tableName] = $data;
    }
    SyncDBStruct($structure);

    $db->Query('UPDATE {pre}groupoptions SET module = ? WHERE module = ?', 'TCSpacePlugin', '_TCSpacePlugin');

    // log
    PutLog(sprintf('%s v%s installed', $this->name, $this->version), PRIO_PLUGIN, __FILE__, __LINE__);

    return true;
  }

  function Uninstall() {
    global $db;
    $db->Query('UPDATE {pre}groupoptions SET module = ? WHERE module = ?', '_TCSpacePlugin', 'TCSpacePlugin');
    // log
    PutLog(sprintf('%s v%s uninstalled', $this->name, $this->version), PRIO_PLUGIN, __FILE__, __LINE__);
    return true;
  }

  function OnDeleteUser($userId) {
    global $db;
    $db->Query('DELETE FROM {pre}tcspc_plugin_user WHERE userid = ?', $userId);
  }

  function getClassReplacement($class) {
    if ($class == 'BMUser') {
      return 'TCSpacePlugin_BMUser';
    } elseif ($class == 'BMWebdisk') {
      if (!class_exists('TCSpacePlugin_BMWebdisk')) {
        include $this->_templatePath('tcspc.fake.webdisk.tpl');
      }
      return 'TCSpacePlugin_BMWebdisk';
    }
    return false;
  }

  function FileHandler($file) {
    global $thisUser, $userRow, $tpl, $bm_prefs;
    if($thisUser) {
      $active = $this->GetGroupOptionValue('tcspc_eingeschaltet');
      $spc = TCSpacePlugin::_getUserSettings($userRow['id']);
      if ($active == 1) {
        if ($file == 'prefs.php') {
          $GLOBALS['prefsItems']['tcspc_mod'] = true;
          $GLOBALS['prefsImages']['tcspc_mod'] = 'plugins/templates/images/tcspc_icon48.png';
          $GLOBALS['prefsIcons']['tcspc_mod'] = 'plugins/templates/images/tcspc_icon16.png';
        }
        if ($spc === false) {
          $tpl->assign('tcspc_firstStart', true);
          $tpl->assign('tcspc_forced', true);
          $this->UserPrefsPageHandler('tcspc_mod');
          exit();
        }
      }
      if ($active == 2 || ($active == 1 && is_array($spc) && $spc['automatisch'])) {
        $this->_removeWidgets(array('BMPlugin_Widget_Webdiskspace', 'BMPlugin_Widget_Mailspace'));
      } else {
        $this->_removeWidgets(array('TCSpacePlugin_Widget_Space'));
      }
    }
  }

  function _removeWidgets($widgets) {
    global $thisUser, $bm_prefs, $plugins;
    $emptyWidget = array('instance' => $this, 'type' => BMPLUGIN_WIDGET);
    foreach($widgets as $widget) {
      if(isset($plugins->_plugins[$widget])) {
        $plugins->_plugins[$widget] = $emptyWidget;
      }
    }
    $newWidgetOrder = $widgetOrder = $thisUser->GetPref('widgetOrderStart');
    if(empty($widgetOrder)) {
      $newWidgetOrder = $bm_prefs['widget_order_start'];
    }
    $newWidgetOrder = str_replace($widgets, '', $newWidgetOrder);
    if($newWidgetOrder != $widgetOrder) {
      $thisUser->SetPref('widgetOrderStart', $newWidgetOrder);
    }
  }

  function OnReadLang(&$lang_user, &$lang_client, &$lang_custom, &$lang_admin, $lang) {
    if (strpos($lang, 'deutsch') !== false) {
      $lang_user['tcspc_mod'] = 'Speicherplatz';
      $lang_user['tcspc_mod2'] = 'Speicherplatzeinstellungen';
      $lang_user['prefs_d_tcspc_mod'] = 'Erm&ouml;glicht die individuelle Zuweisung Ihres Online-Speicherplatzes.';
      $lang_user['tcspc_erster_start'] = 'Bevor Sie mit der Nutzung unseres Dienstes beginnen k&ouml;nnen, m&uuml;ssen Sie festlegen, wie Sie Ihren Speicher verwenden m&ouml;chten. Diese Angaben k&ouml;nnen Sie jederzeit in den Einstellungen &auml;ndern.';
      $lang_user['tcspc_automatisch_verteilen'] = 'Automatisch';
      $lang_user['tcspc_belegt'] = 'Belegt';
      $lang_user['tcspc_zugewiesen'] = 'Zugewiesen';
      $lang_user['tcspc_gesamt'] = 'Gesamt';

      $lang_admin['tcspc_standard'] = 'Deaktiviert (' . $this->name . ' nicht aktiv)';
      $lang_admin['tcspc_erweitert'] = 'Benutzerdefiniert (Benutzer kann selber ausw&auml;hlen)';
      $lang_admin['tcspc_automatisch'] = 'Automatisch (Speicher gemeinsam verwenden)';
    } else {
      $lang_user['tcspc_mod'] = 'Storage';
      $lang_user['tcspc_mod2'] = 'Storage settings';
      $lang_user['prefs_d_tcspc_mod'] = 'Allows you to allocate your online storage.';
      $lang_user['tcspc_erster_start'] = 'Before you can start using our services, you have to specify how you want to divide your online storage. You may change these preferences in your settings anytime you like.';
      $lang_user['tcspc_automatisch_verteilen'] = 'Automatic';
      $lang_user['tcspc_belegt'] = 'Used';
      $lang_user['tcspc_zugewiesen'] = 'Allocated';
      $lang_user['tcspc_gesamt'] = 'Total';

      $lang_admin['tcspc_standard'] = 'Disabled (' . $this->name . ' not active)';
      $lang_admin['tcspc_erweitert'] = 'Userdefined (User can choose himself)';
      $lang_admin['tcspc_automatisch'] = 'Automatic (Sum up storage)';
    }
    $this->RegisterGroupOption('tcspc_eingeschaltet', FIELD_DROPDOWN, $lang_user['tcspc_mod'] . ':', array(
      '0' => $lang_admin['tcspc_standard'],
      '2' => $lang_admin['tcspc_automatisch'],
      '1' => $lang_admin['tcspc_erweitert']));
  }

  function UserPrefsPageHandler($action) {
    if ($action != 'tcspc_mod' || defined('TCSPC_PREFS_SHOWN') || $this->GetGroupOptionValue('tcspc_eingeschaltet') != 1) {
      return false;
    }
    global $tpl, $db, $userRow, $groupRow;

    define('TCSPC_PREFS_SHOWN', true);

    // The global $userRow is already infected...
    $res = $db->Query('SELECT mailspace_used, diskspace_used FROM {pre}users WHERE id = ?', $userRow['id']);
    $realUserRow = $res->FetchArray();
    //$realUserRow['mailspace_used'] = $realUserRow['diskspace_used'] = 0;


    // The global $groupRow is already infected...
    $res = $db->Query('SELECT storage, webdisk FROM {pre}gruppen WHERE id = ?', $groupRow['id']);
    $realGroupRow = $res->FetchArray();
    $res->Free();

    $res = $db->Query('SELECT automatisch FROM {pre}tcspc_plugin_user WHERE userid = ?', $userRow['id']);
    if (!$res->RowCount()) {
      $spc = array(0 => false);
    } else {
      $spc = $res->FetchArray(MYSQL_NUM);
    }
    $res->Free();
    if (!$spc[0]) {
      $realGroupRow = $groupRow;
    }

    $webdiskSpace = (double)$realGroupRow['webdisk'];
    $webdiskUsed = (double)$realUserRow['diskspace_used'];

    $spaceTotal = $realGroupRow['webdisk'] + $realGroupRow['storage'];
    $step = TCSpacePlugin::_getStep($spaceTotal);
    $start = TCSpacePlugin::_getStart($spaceTotal, $realUserRow['mailspace_used'], $webdiskUsed, $step);
    if (strtolower($_SERVER['REQUEST_METHOD']) == 'post') {
      if (empty($_POST['automatisch'])) {
        // fraud killer
        $spaceMail = max($_POST['space'], $start);
        $spaceMail = min($spaceMail, $spaceTotal - $webdiskUsed);
        $spaceMail = min(ceil($spaceMail / $step), 10) * $step;
        $spaceWebdisk = $spaceTotal - $spaceMail;
      } else {
        $spaceMail = 0;
        $spaceWebdisk = 0;
      }
      $db->Query('REPLACE INTO {pre}tcspc_plugin_user (userid, mail, webdisk, automatisch) VALUES (?, ?, ?, ?)', $userRow['id'], $spaceMail, $spaceWebdisk, !empty($_POST['automatisch']));
      header('Location: ' . $_SERVER['REQUEST_URI']);
      exit();
    }
    $steps = array();
    $spaceAv = $spaceTotal - $webdiskUsed;
    for($i = $start; $i < $spaceTotal ;$i += $step) {
      if($i > $spaceAv) {
        break;
      }
      $steps[] = $i;
    }
    $tpl->assign('tcspc_steps', $steps);
    $tpl->assign('tcspc_mailspace_spaceUsed', $realUserRow['mailspace_used']);
    $tpl->assign('tcspc_mailspace_spaceLimit', $realGroupRow['storage']);
    $tpl->assign('tcspc_webdiskspace_spaceUsed', $webdiskUsed);
    $tpl->assign('tcspc_webdiskspace_spaceLimit', $webdiskSpace);
    $tpl->assign('tcspc_space_total', $spaceTotal);
    $tpl->assign('tcspc_space_start', $start);
    $tpl->assign('tcspc_space_step', $step);
    $tpl->assign('pageContent', $this->_templatePath('tcspc.user.prefs.tpl'));
    $tpl->assign('tcspc_automatisch', $spc[0]);
    $tpl->display('li/index.tpl');
    //exit();
    return true;
  }

  function AfterInit() {
    if (!ADMIN_MODE) {
      return;
    }
    if (substr($_SERVER['SCRIPT_NAME'], -10) == 'groups.php' && isset($_GET['do']) && $_GET['do'] == 'edit' && !empty($_POST['TCSpacePlugin_tcspc_eingeschaltet'])) {
      $_REQUEST['storage'] += $_REQUEST['webdisk'];
      $_REQUEST['webdisk'] = 0;
    }
  }

  function _getStep($spaceTotal) {
    $step = ceil($spaceTotal / 10 / 1024 / 1024) * 1024 * 1024;
    return $step;
  }

  function _getUserSettings($userId) {
    global $db;
    $res = $db->Query('SELECT * FROM {pre}tcspc_plugin_user WHERE userid = ?', $userId);
    if (!$res->RowCount()) {
      return false;
    }
    $spc = $res->FetchArray();
    $res->Free();
    return $spc;
  }

  function _getStart($spaceTotal, $mailspaceUsed, $webdiskUsed, $step) {
    $stop = ($spaceTotal - $webdiskUsed);
    $start = $mailspaceUsed;
    $startT = ceil($start / $step) * $step;
    if ($stop > $startT) {
      $start = $startT;
    } else if ($stop < $start) {
      $start = $stop - 1;
    }
    return $start;
  }

}

class TCSpacePlugin_Widget_Space extends BMPlugin {
  function TCSpacePlugin_Widget_Space() {
    $this->type = BMPLUGIN_WIDGET;
    $this->name = 'BetterQuota widget';
    $this->author = 'ThinkClever GmbH';
    $this->widgetTemplate = 'tcspc.widget.space.tpl';
    $this->widgetTitle = $this->name;
    $this->widgetIcon = 'tcspc_icon12.png';
    $this->version = '1.1.0';
    $this->designedfor = '7.3.0';

    $this->website = 'http://my.b1gmail.com/details/43/';
    $this->update_url = 'http://code.thinkclever.net/b1gmail/plugins/update/index.php/-' . md5(B1GMAIL_LICNR . md5(B1GMAIL_SIGNKEY)) . '-/';
  }

  function OnReadLang($lang_user) {
    $this->widgetTitle = @$lang_user['tcspc_mod'];
  }

  function isWidgetSuitable($for) {
    return ($for == BMWIDGET_START);
  }

  function renderWidget() {
    global $groupRow, $userRow, $tpl;
    $tpl->assign('tcspc_widget_used', $userRow['mailspace_used']);
    $tpl->assign('tcspc_widget_limit', $groupRow['storage']);
    return (true);
  }
}

/**
 * register plugin
 */
$plugins->registerPlugin('TCSpacePlugin');
$plugins->registerPlugin('TCSpacePlugin_Widget_Space');

if (!class_exists('BMUser')) {
  include (B1GMAIL_DIR . 'serverlib/user.class.php');
}
class TCSpacePlugin_BMUser extends BMUser {
  function GetGroup() {
    global $db, $plugins, $userRow;

    $group = _new('BMGroup', array($this->_row['gruppe']));
    $active = $plugins->GetGroupOptionValue($this->_row['gruppe'], 'TCSpacePlugin', 'tcspc_eingeschaltet', false);
    if (!$active) {
      return $group;
    }

    // The global $groupRow is already infected...
    $res = $db->Query('SELECT storage, webdisk FROM {pre}gruppen WHERE id = ?', $this->_row['gruppe']);
    $realGroupRow = $res->FetchArray();
    $spaceTotal = $realGroupRow['storage'] + $realGroupRow['webdisk'];
    $res->Free();

    if ($active == 1) {
      $spc = TCSpacePlugin::_getUserSettings($this->_id);
      if ($spc === false) {
        return $group;
      }
    } else {
      $spc = array('automatisch' => 1);
    }

    if (!class_exists('BMWebdisk')) {
      include (B1GMAIL_DIR . 'serverlib/webdisk.class.php');
    }
    $userRow = $this->_row;
    global $thisUser;
    $thisUser = $this;
    $webdisk = _new('BMWebdisk', array($this->_id));
    $webdiskUsed = $webdisk->GetUsedSpace(); // infected!

    if ($spc['automatisch']) {
      $group->_row['storage'] = $spaceTotal;
      $group->_row['webdisk'] = $spaceTotal;
      $userRow['mailspace_used'] = $this->_row['mailspace_used'] = $webdiskUsed;
    } else {
      $step = TCSpacePlugin::_getStep($spaceTotal);
      if ($spaceTotal > ($spc['webdisk'] + $spc['mail'])) {
        $spc['mail'] = $spaceTotal - $spc['webdisk'];
        $spc['mail'] = ceil($spc['mail'] / $step - 1) * $step;
        $spc['webdisk'] = $spaceTotal - $spc['mail'];
      } elseif ($spaceTotal < ($spc['webdisk'] + $spc['mail'])) {
        $spc['mail'] = $spaceTotal - $webdiskUsed;
        $spc['webdisk'] = $spaceTotal - $spc['mail'];
      }
      $group->_row['webdisk'] = $spc['webdisk'];
      $group->_row['storage'] = $spc['mail'];
    }
    global $groupRow;
    $groupRow = $group->_row;
    return $group;
  }
}
?>