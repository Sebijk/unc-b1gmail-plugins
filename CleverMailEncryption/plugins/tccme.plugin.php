<?php
/**
 * TCMailEncryptionPlugin
 *
 * MIT License
 *
 * Copyright (c) 2025 Nils Caspar, b1gMail.eu Project

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.*/
class TCMailEncryptionPlugin extends BMPlugin
{
  function __construct()
  {
    $this->name = 'CleverMailEncryption';
    $this->author = 'b1gMail.eu Project, ThinkClever GmbH';
    $this->web = 'http://www.b1gmail.eu/';
    $this->version = '1.2.0';
    $this->designedfor = '7.4.1';
    $this->type = BMPLUGIN_DEFAULT;
    $this->order = 100;

    $this->admin_pages = true;
    $this->admin_page_title = $this->name;
    $this->admin_page_icon = 'tccme_icon48.png';

    $this->RegisterGroupOption('tccme_eingeschaltet', FIELD_CHECKBOX, $this->name . '?');
  }

  function Install()
  {
    global $db, $mysql;

    $databaseStructure = '{
      "{pre}tccme_plugin_mail": {
          "fields": [
              [
                  "mail_id",
                  "int(11) unsigned",
                  "NO",
                  "PRI",
                  null,
                  ""
              ],
              [
                  "user_id",
                  "int(11)",
                  "NO",
                  "MUL",
                  null,
                  ""
              ]
          ],
          "indexes": {
              "PRIMARY": [
                  "mail_id"
              ],
              "user_id": [
                  "user_id"
              ]
          }
      },
      "{pre}tccme_plugin_queue": {
          "fields": [
              [
                  "id",
                  "int(11) unsigned",
                  "NO",
                  "PRI",
                  null,
                  "auto_increment"
              ],
              [
                  "user_id",
                  "int(11) unsigned",
                  "NO",
                  "MUL",
                  null,
                  ""
              ],
              [
                  "date_added",
                  "int(11) unsigned",
                  "NO",
                  "",
                  null,
                  ""
              ],
              [
                  "mails_processed",
                  "int(11) unsigned",
                  "NO",
                  "",
                  null,
                  ""
              ],
              [
                  "finished",
                  "tinyint(1)",
                  "NO",
                  "MUL",
                  "0",
                  ""
              ],
              [
                  "locked",
                  "int(11)",
                  "NO",
                  "",
                  null,
                  ""
              ]
          ],
          "indexes": {
              "PRIMARY": [
                  "id"
              ],
              "finished": [
                  "finished"
              ],
              "user_id": [
                  "user_id"
              ]
          }
      },
      "{pre}tccme_plugin_settings": {
          "fields": [
              [
                  "schluessellaenge",
                  "int(11)",
                  "NO",
                  "",
                  "4096",
                  ""
              ]
          ],
          "indexes": []
      }
  }';
    $databaseStructure = json_decode($databaseStructure, JSON_OBJECT_AS_ARRAY);
    $structure = [];
    foreach ($databaseStructure as $tableName => $data) {
      $tableName = str_replace('{pre}', $mysql['prefix'], $tableName);
      $structure[$tableName] = $data;
    }
    SyncDBStruct($structure);

    // prefs row?
    $res = $db->Query('SELECT COUNT(*) FROM {pre}tccme_plugin_settings');
    [$rowCount] = $res->FetchArray(MYSQLI_NUM);
    $res->Free();

    // insert prefs row
    if ($rowCount < 1) {
      $db->Query('INSERT INTO `{pre}tccme_plugin_settings` () VALUES ()');
    }

    $db->Query('UPDATE {pre}groupoptions SET module = ? WHERE module = ?', 'TCMailEncryptionPlugin', '_TCMailEncryptionPlugin');

    $this->_cleanUpMails();

    // log
    PutLog(sprintf('%s v%s installed', $this->name, $this->version), PRIO_PLUGIN, __FILE__, __LINE__);

    return true;
  }

  public function Uninstall()
  {
    global $db;

    $db->Query('UPDATE {pre}groupoptions SET module = ? WHERE module = ?', '_TCMailEncryptionPlugin', 'TCMailEncryptionPlugin');
    // log
    PutLog(sprintf('%s v%s uninstalled', $this->name, $this->version), PRIO_PLUGIN, __FILE__, __LINE__);
    return true;
  }

  public function OnDeleteUser($userId)
  {
    global $db;

    $db->Query('DELETE FROM {pre}tccme_plugin_queue WHERE user_id = ?', $userId);
    $db->Query('DELETE FROM {pre}tccme_plugin_mail WHERE user_id = ?', $userId);
  }

  public function AfterDeleteMail($mailID, &$mailbox)
  {
    global $db;

    $db->Query('DELETE FROM {pre}tccme_plugin_mail WHERE mail_id = ?', $mailID);
  }

  public function OnReadLang(&$lang_user, &$lang_client, &$lang_custom, &$lang_admin, $lang)
  {
    if (strpos($lang, 'deutsch') !== false) {
      $lang_admin['tccme.keine_gruppe_aktiviert'] = 'Bitte aktivieren Sie ' . $this->name . ' für mindestens eine Gruppe. Sie finden diese Einstellung in den Gruppeneinstellungen von b1gMail.';
      $lang_admin['tccme.verschluesselte_mails'] = $lang_user['tccme.verschluesselte_mails'] = 'Verschlüsselte E-Mails';
      $lang_admin['tccme.openssl_support'] = 'OpenSSL-Support';
      $lang_admin['tccme.hinweis_warteschlange'] = 'In der Warteschlange befinden sich E-Mails, die auf die Verschlüsselung warten.';
      $lang_admin['tccme.warteschlange_abarbeiten_beschreibung'] = $lang_admin['tccme.hinweis_warteschlange'] . ' Sie können den Vorgang durch Klicken der untenstehenden Schaltfläche beschleunigen.';
      $lang_admin['tccme.warteschlange_abarbeiten'] = 'E-Mails verschlüsseln';
      $lang_admin['tccme.javascript_aktivieren'] = 'Damit Sie diese Funktion nutzen können, müssen Sie JavaScript im Browser aktivieren.';
      $lang_admin['tccme.mails_verarbeitet'] = 'E-Mails verschlüsselt';

      $lang_admin['tccme.schluessellaenge'] = 'Schlüssellänge (Bit)';
      $lang_admin['tccme.schluessellaenge_empfohlen'] = 'empfohlen';

      $lang_admin['tccme.passwort_aendern'] = 'Die E-Mails dieses Benutzers wurden verschlüsselt abgelegt. Sollte der Benutzer kein Backup des Private Keys haben, gehen beim ändern des Passworts durch den Administrator <b>sämtliche Nachrichten verloren</b>.';
      $lang_admin['tccme.passwort_aendern_bestaetigen'] = 'Ich habe die Warnung verstanden und möchte fortfahren.';

      $lang_user['tccme_mod'] = 'Verschlüsselung';
      $lang_user['tccme_mod2'] = 'Verschlüsselung';
      $lang_user['prefs_d_tccme_mod'] = 'übersicht über die Sicherheit Ihrer E-Mails.';
      $lang_user['tccme.backup_hinweis'] = 'Ihre E-Mails werden verschlüsselt auf unseren Servern abgelegt. Sollten Sie Ihr Passwort vergessen, haben Sie keinen Zugriff mehr auf Ihre alten Nachrichten. Wir empfehlen Ihnen deshalb, ein Backup des Keys herunterzuladen und sicher aufzubewahren.';

      $lang_user['tccme.status_fertig'] = 'Verschlüsselung abgeschlossen';
      $lang_user['tccme.status_laeuft'] = 'Verschlüsselung läuft';
      $lang_user['tccme.status_key_fehlt'] = 'Privater Schlüssel fehlt';
      $lang_user['tccme.private_key'] = 'Privater Schlüssel';
      $lang_user['tccme.backup_herunterladen'] = 'Backup herunterladen';
      $lang_user['tccme.key_nicht_geladen'] = 'Ihre E-Mails wurden verschlüsselt auf unseren Servern abgelegt. Der notwendige Schüssel konnte nicht geladen werden. Bitte spielen Sie ein Backup Ihres Schlüssels ein oder generieren Sie ein neues Schlüsselpaar.';
      $lang_user['tccme.backup_hochladen'] = 'Backup';

      $lang_user['tccme.neue_schluessel'] = 'Neues Schlüsselpaar generieren';
      $lang_user['tccme.neue_schluessel_warnung'] = 'Wenn Sie ein neues Schlüsselpaar generieren, gehen <b>sämtliche Nachrichten verloren</b>. Ihre Nachrichten werden unwiderruflich gelöscht.';
      $lang_user['tccme.neue_schluessel_bestaetigen'] = 'Ich habe die Warnung verstanden und möchte fortfahren.';
      $lang_user['tccme.passwort_verloren'] = 'Ihre E-Mails wurden verschlüsselt auf unseren Servern abgelegt. Sollten Sie kein Backup des privaten Schlüssels haben, gehen beim Zurücksetzen des Passworts <b>sämtliche Nachrichten verloren</b>. Wenn Sie wirklich Fortfahren möchten, setzen Sie sich bitte mit uns in Verbindung.';
    } else {
      $lang_admin['tccme.keine_gruppe_aktiviert'] = 'Please activate ' . $this->name . ' for at least one group. You can do so by changing the group settings of b1gMail.';
      $lang_admin['tccme.verschluesselte_mails'] = $lang_user['tccme.verschluesselte_mails'] = 'Encrypted e-mails';
      $lang_admin['tccme.openssl_support'] = 'OpenSSL support';
      $lang_admin['tccme.hinweis_warteschlange'] = 'There are unencrypted e-mails waiting in the queue.';
      $lang_admin['tccme.warteschlange_abarbeiten_beschreibung'] = $lang_admin['tccme.hinweis_warteschlange'] . ' You can speed up this process by clicking the button below.';
      $lang_admin['tccme.warteschlange_abarbeiten'] = 'Encrypt e-mails';
      $lang_admin['tccme.javascript_aktivieren'] = 'You need to enable JavaScript in order to use this function.';
      $lang_admin['tccme.mails_verarbeitet'] = 'e-mails encrypted';

      $lang_admin['tccme.schluessellaenge'] = 'Keylength (bits)';
      $lang_admin['tccme.schluessellaenge_empfohlen'] = 'recommended';
      $lang_admin['tccme.passwort_aendern'] = "This user has encrypted e-mails. By changing the user's password, <strong>all of his e-mails</strong> will be lost in case he doesn't have a backup of his privatekey!";
      $lang_admin['tccme.passwort_aendern_bestaetigen'] = 'I have read and understood the warning and would still like to proceed.';

      $lang_user['tccme_mod'] = 'Encryption';
      $lang_user['tccme_mod2'] = 'Encryption';
      $lang_user['prefs_d_tccme_mod'] = 'Encryption status of your e-mails.';
      $lang_user['tccme.backup_hinweis'] = 'Your e-mails will be stored encrypted on our servers. If you should ever forget your password, you cannot access your e-mails anymore. Therefore, we strongly recommend to download a copy of your key and store it in a safe location.';
      $lang_user['tccme.status_fertig'] = 'Encryption completed';
      $lang_user['tccme.status_laeuft'] = 'Encryption pending';
      $lang_user['tccme.status_key_fehlt'] = 'Missing privatekey';
      $lang_user['tccme.private_key'] = 'Privatekey';
      $lang_user['tccme.backup_herunterladen'] = 'Download backup';

      $lang_user['tccme.key_nicht_geladen'] = 'Your e-mails have been stored encrypted on our servers. The necessary keypair could not be found. Please upload a backup of your key (recommended) or generate a new keypair.';
      $lang_user['tccme.backup_hochladen'] = 'Backup';
      $lang_user['tccme.neue_schluessel'] = 'Generate new keypair';
      $lang_user['tccme.neue_schluessel_warnung'] = 'If you generate a new keypair, <strong>all of your e-mails</strong> will be deleted immediately and irrevocably!';
      $lang_user['tccme.neue_schluessel_bestaetigen'] = 'I have read and understood the warning and would still like to proceed.';

      $lang_user['tccme.passwort_verloren'] = "Your e-mails have been stored encrypted on our servers. If you don't have a backup of your privatekey, <strong>all of your e-mails</strong> will be lost after resetting the password. Please contact us, if you'd still like to proceed.";
    }
  }

  public function OnLogin($userID, $interface = 'web')
  {
    global $db, $bm_prefs;

    if (isset($_REQUEST['passwordMD5']) && $_REQUEST['passwordMD5'] == md5(md5($bm_prefs['adminpw']) . $_SERVER['HTTP_USER_AGENT'] . $_SERVER['REMOTE_ADDR'])) {
      $_SESSION['tccme_isAdmin'] = true;
    }
    $this->_cleanUpUserMails($userID);
    $this->_loadPrivateKey($userID);
  }

  private function _cleanUpUserMails($userId)
  {
    global $db;

    $db->Query('DELETE FROM {pre}tccme_plugin_mail WHERE user_id = ? AND mail_id NOT IN (SELECT id FROM {pre}mails WHERE userid = ?)', $userId, $userId);
  }

  private function _cleanUpMails()
  {
    global $db;

    $db->Query('DELETE FROM {pre}tccme_plugin_mail WHERE user_id NOT IN (SELECT id FROM {pre}users)');
    $db->Query('DELETE FROM {pre}tccme_plugin_mail WHERE mail_id NOT IN (SELECT id FROM {pre}mails)');
  }

  private function _loadPrivateKey($userId)
  {
    if (empty($_SESSION['tccme_privateKey']) && empty($_SESSION['tccme_isAdmin'])) {
      $privateKey = $this->_getPrivateKey($userId, $_SESSION['bm_xorCryptKey']);
      $_SESSION['tccme_privateKey'] = $privateKey;
    }
  }

  private function _deleteAllMessages($userId)
  {
    // load classes, if needed
    if (!class_exists('BMMailbox')) {
      include (B1GMAIL_DIR . 'serverlib/mailbox.class.php');
    }
    if (!class_exists('BMUser')) {
      include (B1GMAIL_DIR . 'serverlib/user.class.php');
    }

    // create objects...
    $bUser = _new('BMUser', [$userId]);
    /* @var $bMailbox BMMailbox */
    $bMailbox = _new('BMMailbox', [$userId, '', $bUser]);

    $folders = $bMailbox->GetFolderList();
    foreach (array_keys($folders) as $folderId) {
      $mails = $bMailbox->GetMailIDList($folderId);
      foreach ($mails as $mailId) {
        $bMailbox->DeleteMail($mailId, true);
      }
    }
  }

  public function FileHandler($file, $action)
  {
    global $thisUser, $cacheManager, $tpl;

    if (empty($thisUser) || !$this->GetGroupOptionValue('tccme_eingeschaltet')) {
      return;
    }

    $userId = $thisUser->_id;
    $this->_loadPrivateKey($userId);

    if (empty($_SESSION['tccme_privateKey']) && empty($_SESSION['tccme_isAdmin']) && (!isset($_REQUEST['action']) || $_REQUEST['action'] != 'logout')) {
      $this->_handlePrivateKeyUpload($userId);
    }

    if ($file == 'prefs.php') {
      $GLOBALS['prefsItems']['tccme_mod'] = true;
      $GLOBALS['prefsfaIcons']['tccme_mod'] = 'fa-lock';
    }

    $this->_checkMailQueue($userId);

    if ($file == 'index.php' && $action == 'lostPassword') {
      $this->_handleLostPassword();
    }
  }

  public function AfterInit()
  {
    global $cacheManager;

    if (is_a($cacheManager, 'BMCache_b1gMail')) {
      $cacheManager = new TCMailEncryptionPlugin_BMCache_b1gMail();
    } elseif (is_a($cacheManager, 'BMCache_memcache')) {
      $cacheManager = new TCMailEncryptionPlugin_BMCache_memcache();
    }
    if (!IsPOSTRequest()) {
      return;
    }
    $file = (basename($_SERVER['SCRIPT_FILENAME']));
    if ($file === 'users.php' && isset($_REQUEST['save']) && isset($_REQUEST['do']) && $_REQUEST['do'] == 'edit' && !empty($_REQUEST['passwort'])) {
      if (!isset($_REQUEST['__tccme_deletion_confirmed'])) {
        RequestPrivileges(PRIVILEGES_ADMIN);

        global $tpl, $lang_admin;

        if (!$this->_getPublicKey($_REQUEST['id'])) {
          return;
        }
        $tpl->assign('page', $this->_templatePath('tccme.admin.password.tpl'));
        $tpl->assign('title', $lang_admin['usersgroups'] . ' &raquo; ' . $lang_admin['users']);
        $tpl->display('page.tpl');
        exit;
      }
    }
  }

  public function OnUserPasswordChange($userId, $password1, $password2, $passwordPlain)
  {
    if (empty($_SESSION['tccme_privateKey']) || empty($_SESSION['bm_xorCryptKey'])) {
      PutLog(sprintf('Session variables for user #%d not set... This may result in data loss!', $userId), PRIO_ERROR, __FILE__, __LINE__);
      return;
    }
    $pkey = @openssl_pkey_get_private($_SESSION['tccme_privateKey']);
    if (!$pkey) {
      PutLog(sprintf('Could not load private key for user #%d... This may result in data loss! %s', $userId, openssl_error_string()), PRIO_ERROR, __FILE__, __LINE__);
      return;
    }
    $privateKey = false;
    $newXorCryptKey = BMUser::GenerateXORCryptKey($userId, $passwordPlain);
    if (!@openssl_pkey_export($pkey, $privateKey, $newXorCryptKey)) {
      PutLog(sprintf('Could not export private key for user #%d... This may result in data loss! %s', $userId, openssl_error_string()), PRIO_ERROR, __FILE__, __LINE__);
      return;
    }
    $user = _new('BMUser', [$userId]);
    $user->SetPref('tccme_privateKey', $privateKey);
  }

  public function UserPrefsPageHandler($action)
  {
    if ($action != 'tccme_mod' || defined('TCCME_PREFS_SHOWN') || !$this->GetGroupOptionValue('tccme_eingeschaltet')) {
      return false;
    }

    global $tpl, $db, $userRow;

    define('TCCME_PREFS_SHOWN', true);

    if (isset($_POST['tccme_backup'])) {
      $fileName = isset($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] . '-' : '';
      $fileName .= 'private_key.tccme';
      $key = gzdeflate($_SESSION['tccme_privateKey']);
      header('Pragma: public');
      header('Content-Disposition: attachment; filename="' . $fileName . '"');
      header('Content-Type: application/octet-stream');
      header(sprintf('Content-Length: %d', strlen($key)));
      echo $key;
      return null;
    }

    $this->_cleanUpUserMails($userRow['id']);

    $res = $db->Query('SELECT COUNT(*) FROM {pre}tccme_plugin_mail WHERE user_id = ?', $userRow['id']);
    [$mailCount] = $res->FetchArray(MYSQLI_NUM);
    $tpl->assign('tccme_mailCount', $mailCount);

    $res = $db->Query('SELECT COUNT(*) FROM {pre}mails WHERE userid = ?', $userRow['id']);
    [$totalMailcount] = $res->FetchArray(MYSQLI_NUM);
    $tpl->assign('tccme_totalMailCount', $totalMailcount);
    if ($totalMailcount == 0) {
      $percent = 100;
    } else {
      $percent = round(100 / $totalMailcount * $mailCount, 2);
      if ($percent == 100 && $totalMailcount != $mailCount) {
        $percent = 99.99;
      }
    }
    $tpl->assign('tccme_mailCountPercent', $percent);
    $tpl->assign('tccme_hasKey', !empty($_SESSION['tccme_privateKey']));

    $tpl->assign('pageContent', $this->_templatePath('tccme.user.prefs.tpl'));
    $tpl->display('li/index.tpl');
    return null;
  }

  public function OnCron()
  {
    $this->_workOffQueue();
    if (random_int(1, 10) == 1) {
      global $db;

      $db->Query('DELETE FROM {pre}tccme_plugin_queue WHERE finished = 1 AND date_added < ' . (time() - TIME_ONE_DAY));
      $this->_cleanUpMails();
    }
  }

  private function _workOffQueue()
  {
    global $db;
    $mailLimit = 20;
    $userLimit = 5;

    // Fetch users from the queue
    $res = $db->Query('SELECT id, user_id, mails_processed FROM {pre}tccme_plugin_queue WHERE finished = 0 AND locked < ' . (time() - 60) . ' ORDER BY RAND() LIMIT ' . $userLimit);
    $userCount = $res->RowCount();
    if (empty($userCount)) {
      return null;
    }

    $users = [];
    $queues = [];
    while ($row = $res->FetchArray(MYSQLI_ASSOC)) {
      $users[] = $row;
      $queues[] = $row['id'];
    }
    $res->Free();

    $queues = array_column($users, 'id');

    // Lock the selected users
    $db->query('UPDATE {pre}tccme_plugin_queue SET locked = ? WHERE id IN (' . implode(', ', $queues) . ')', time());

    // Load classes if needed
    if (!class_exists('BMMailbox')) {
      require (B1GMAIL_DIR . 'serverlib/mailbox.class.php');
    }
    if (!class_exists('BMUser')) {
      require (B1GMAIL_DIR . 'serverlib/user.class.php');
    }

    $mailLimit = round(($userLimit / $userCount) * $mailLimit);
    $totalMailsProcessed = 0;

    foreach ($users as $row) {
      $bUser = _new('BMUser', [$row['user_id']]);
      $bMailbox = _new('BMMailbox', [$row['user_id'], $bUser->GetDefaultSender(), $bUser]);

      // Fetch mails
      $mailRes = $db->Query('SELECT * FROM {pre}mails WHERE userid = ? AND id NOT IN (SELECT mail_id FROM {pre}tccme_plugin_mail WHERE user_id = ?) LIMIT ?', $row['user_id'], $row['user_id'], $mailLimit);
      $mailCounter = 0;

      while ($mail = $mailRes->FetchArray(MYSQLI_ASSOC)) {
        ++$mailCounter;
        ++$totalMailsProcessed;
        $bMail = _new('BMMail', [$mail['userid'], $mail, false, false]);
        $this->_encryptMail($bMail, $bMailbox);
      }
      // Update queue status
      $finished = $mailCounter < $mailLimit ? 1 : 0;
      $db->Query('UPDATE {pre}tccme_plugin_queue SET locked = 0, finished = ?, mails_processed = ? WHERE id = ?', $finished, ($row['mails_processed'] + $mailCounter), $row['id']);
      $mailRes->Free();
    }

    return $totalMailsProcessed;
  }

  /**
   * @param BMMail $bmMail
   * @param BMMailbox $mailbox
   */
  private function _encryptMail($bmMail, $mailbox)
  {
    global $db;
    $userId = $mailbox->_userID;
    $mailId = $bmMail->id;
    $bUser = $mailbox->_userObject;

    // Query user in group
    $res = $db->Query('SELECT gruppe FROM {pre}users WHERE id = ?', $userId);
    if (!$res->RowCount()) {
      // throw new Exception('User group not found.');
      return false;
    }
    [$group] = $res->FetchArray(MYSQLI_NUM);

    if (!$this->GetGroupOptionValue('tccme_eingeschaltet', $group)) {
      return false;
    }

    $cert = $this->_getCert($userId, $bUser);
    if (!$cert) {
      // throw new Exception('Certificate not found.');
      return false;
    }

    // Create temp file
    $tempFileID = RequestTempFile($userId, time() + 5 * TIME_ONE_MINUTE);
    $sourceFileName = TempFileName($tempFileID);
    $messageFP = BMBlobStorage::createProvider($bmMail->blobStorage, $userId)->loadBlob(BMBLOB_TYPE_MAIL, $mailId);

    // Store message in temporary file
    if (is_resource($messageFP)) {
      file_put_contents($sourceFileName, stream_get_contents($messageFP));
    }

    // Create Target tempfile
    $destTempID = RequestTempFile($userId, time() + TIME_ONE_MINUTE);
    $destinationFileName = TempFileName($destTempID);

    // Check if message is not encrypted
    if (!isset($bmMail->headers['X-EncodedBy']) || $bmMail->GetHeaderValue('X-EncodedBy') != 'CleverMailEncryption') {
      // Do encryption
      if (!openssl_pkcs7_encrypt($sourceFileName, $destinationFileName, $cert, [
        'X-EncodedBy' => $this->name . '/' . $this->version
      ])) {
        throw new Exception(sprintf('Could not encrypt message <%d>: %s', $mailId, openssl_error_string()));
      }

      // Store encrypted mail
      if (!BMBlobStorage::createProvider($bmMail->blobStorage, $userId)->storeBlob(BMBLOB_TYPE_MAIL, $mailId, file_get_contents($destinationFileName))) {
        // throw new Exception(sprintf('Could not write encrypted message <%d>. Permission denied?', $mailId));
        PutLog(sprintf('Could not write encrypted message <%d>. Permission denied?', $mailId), PRIO_ERROR, __FILE__, __LINE__);
      }
    } else {
      PutLog(sprintf('Could not encrypt <%d>. Already encrypted.', $mailId), PRIO_ERROR, __FILE__, __LINE__);
    }

    $db->Query('REPLACE INTO {pre}tccme_plugin_mail (mail_id, user_id) VALUES (?, ?)', $mailId, $userId);
    $bmMail->flags |= FLAG_DECEPTIVE;
    $mailbox->FlagMail(FLAG_DECEPTIVE, true, $mailId);

    return true;
  }

  /**
   * @param int $mailID
   * @param BMMail $mail
   * @param BMMailbox $mailbox
   */
  public function AfterStoreMail($mailID, &$mail, &$mailbox)
  {
    $mail->id = $mailID;
    $this->_encryptMail($mail, $mailbox);
  }

  /**
   * @param int $id
   * @param bool $allowOverride
   * @param BMMail $mail
   */
  public function OnGetMessageFP($id, $allowOverride, &$mail)
  {
    global $db;
    if (!isset($_SESSION['tccme_privateKey'])) {
      return false;
    }

    $res = $db->Query('SELECT * FROM {pre}tccme_plugin_mail WHERE mail_id = ?', $mail->id);
    if (!$res->RowCount()) {
      return false;
    }

    $privateKey = openssl_get_privatekey($_SESSION['tccme_privateKey']);
    $userId = $mail->_userID;
    $cert = openssl_x509_read($this->_getCert($userId));

    // Load blob
    $messageFPTemp = BMBlobStorage::createProvider($mail->blobStorage, $userId)->loadBlob(BMBLOB_TYPE_MAIL, $id);
    $tempFileID = RequestTempFile($userId, time() + 5 * TIME_ONE_MINUTE);
    $sourceFileName = TempFileName($tempFileID);
    $GLOBALS['tempFilesToReleaseAtShutdown'][] = [$userId, $tempFileID];

    // Store message in temporary file
    if (is_resource($messageFPTemp)) {
      file_put_contents($sourceFileName, stream_get_contents($messageFPTemp));
    }

    // Check if file can be opened
    $encodingHeader = @file_get_contents($sourceFileName, false, null, 0, 33);
    if ($encodingHeader === false) {
      PutLog(sprintf("Message <%d> can't be read or is empty", $mail->id), PRIO_WARNING, __FILE__, __LINE__);
      return false;
    }

    if (trim($encodingHeader) !== 'X-EncodedBy: CleverMailEncryption') {
      PutLog(sprintf('Message <%d> is not properly encrypted. Deleting internal reference.', $mail->id), PRIO_WARNING, __FILE__, __LINE__);
      $db->Query('DELETE FROM {pre}tccme_plugin_mail WHERE mail_id = ?', $mail->id);
      return false;
    }

    // Create temp file
    $destinationFileID = RequestTempFile($userId, time() + 5 * TIME_ONE_MINUTE);
    $destinationFileName = TempFileName($destinationFileID);
    $GLOBALS['tempFilesToReleaseAtShutdown'][] = [$userId, $destinationFileID];

    // Do decryption
    if (!@openssl_pkcs7_decrypt($sourceFileName, $destinationFileName, $cert, $privateKey)) {
      PutLog(sprintf('Could not decrypt message <%d>: %s', $mail->id, openssl_error_string()), PRIO_ERROR, __FILE__, __LINE__);
      return false;
    }

    // Rückgabe des Dateizeigers der entschlüsselten Datei
    return @file_get_contents($destinationFileName) ?: false;
  }

  public $_config;

  private function _handleLostPassword()
  {
    if (!isset($_REQUEST['email_full']) && !(isset($_REQUEST['email_local']) && isset($_REQUEST['email_domain']))) {
      return;
    }

    $userMail = isset($_REQUEST['email_full'])
      ? trim($_REQUEST['email_full'])
      : trim($_REQUEST['email_local']) . '@' . $_REQUEST['email_domain'];
    $userId = BMUser::GetID($userMail, true);

    if ($this->_getPublicKey($userId)) {
      global $tpl, $lang_user;

      $tpl->assign('title', $lang_user['tccme_mod']);
      $tpl->assign('msg', $lang_user['tccme.passwort_verloren']);
      $tpl->assign('page', 'nli/msg.tpl');
      $tpl->display('nli/index.tpl');
      exit;
    }
  }

  private function _handlePrivateKeyUpload($userId)
  {
    global $tpl;

    if (isset($_POST['tccme_deletion_confirmed'])) {
      $this->_deleteAllMessages($userId);
      unset($_SESSION['tccme_privateKey']);
      $thisUser->SetPref('tccme_privateKey', '');
      $this->_loadPrivateKey($userId);
      return;
    }

    if (isset($_FILES['tccme_key']) && !$_FILES['tccme_key']['error']) {
      $privateKey = file_get_contents($_FILES['tccme_key']['tmp_name']);
      $privateKey = @gzinflate($privateKey);
      if ($privateKey) {
        $privateKey = openssl_pkey_get_private($privateKey);
        $keyPairDetails = openssl_pkey_get_details($privateKey);
        $publicKey = $keyPairDetails['key'];

        if ($publicKey && $publicKey == $this->_getPublicKey($userId, $thisUser)) {
          openssl_pkey_export($privateKey, $privateKey, $_SESSION['bm_xorCryptKey']);
          $thisUser->SetPref('tccme_privateKey', $privateKey);
          $this->_loadPrivateKey($userId);
          return;
        }
      }
    }

    $tpl->assign('pageContent', $this->_templatePath('tccme.user.nokey.tpl'));
    $tpl->display('li/index.tpl');
    exit;
  }

  private function _checkMailQueue($userId)
  {
    global $db;

    $res = $db->Query('SELECT id FROM {pre}tccme_plugin_queue WHERE user_id = ? AND finished != 1 LIMIT 1', $userId);
    if ($res->FetchArray() === false) {
      $mailRes = $db->Query('SELECT id FROM {pre}mails WHERE userid = ? AND id NOT IN (SELECT mail_id FROM {pre}tccme_plugin_mail WHERE user_id = ?) LIMIT 1', $userId, $userId);
      if ($mailRes->FetchArray() !== false) {
        $db->Query('INSERT INTO {pre}tccme_plugin_queue (user_id, date_added) VALUES (?, ?)', $userId, time());
      }
      $res->Free();
      $mailRes->Free();
    }
  }

  private function _getConfig()
  {
    global $db;

    if (empty($this->_config)) {
      $res = $db->Query('SELECT * FROM {pre}tccme_plugin_settings LIMIT 1');
      $config = $res->FetchArray();
      $res->Free();
      $this->_config = $config;
    }
    return $this->_config;
  }

  private function _getCert($userId, $user = null)
  {
    global $cacheManager;

    if (is_object($cacheManager)) {
      $cert = $cacheManager->Get('tccme_cert_' . $userId);
      if ($cert !== false) {
        return $cert;
      }
    }
    if ($user == null) {
      /* @var $user BMUser */
      $user = _new('BMUser', [$userId]);
    }
    $cert = $user->GetPref('tccme_cert');
    if (is_object($cacheManager)) {
      $cacheManager->Set('tccme_cert_' . $userId, $cert);
    }
    return $cert;
  }

  private function _getPublicKey($userId, $user = null)
  {
    global $cacheManager;

    if (is_object($cacheManager)) {
      $pkey = $cacheManager->Get('tccme_pkey_' . $userId);
      if ($pkey !== false) {
        return $pkey;
      }
    }
    if ($user == null) {
      if (!class_exists('BMUser')) {
        include (B1GMAIL_DIR . 'serverlib/user.class.php');
      }
      /* @var $user BMUser */
      $user = _new('BMUser', [$userId]);
    }
    $pkey = $user->GetPref('tccme_publicKey');
    if (is_object($cacheManager)) {
      $cacheManager->Set('tccme_pkey_' . $userId, $pkey);
    }
    return $pkey;
  }

  private function _getPrivateKey($userId, $cryptKey, $user = null)
  {
    global $cacheManager;

    if ($user == null) {
      /* @var $user BMUser */
      $user = _new('BMUser', [$userId]);
    }
    $privateKey = $user->GetPref('tccme_privateKey');
    if (!$privateKey) {
      if (!$this->GetGroupOptionValue('tccme_eingeschaltet', $user->_row['gruppe'])) {
        return false;
      }
      $config = $this->_getConfig();
      $keyBits = (int) $config['schluessellaenge'];
      $keyPair = openssl_pkey_new([
        'private_key_type' => OPENSSL_KEYTYPE_RSA,
        'private_key_bits' => $keyBits
      ]);
      $csr = openssl_csr_new(['commonName' => $userId], $keyPair);
      $ssCert = openssl_csr_sign($csr, null, $keyPair, 365 * 100);
      $certOut = '';
      openssl_x509_export($ssCert, $certOut);
      $keyPairDetails = openssl_pkey_get_details($keyPair);
      openssl_pkey_export($keyPair, $privateKey, $cryptKey);
      $publicKey = $keyPairDetails['key'];
      $user->SetPref('tccme_privateKey', $privateKey);
      $user->SetPref('tccme_publicKey', $publicKey);
      $user->SetPref('tccme_cert', $certOut);
      if (is_object($cacheManager)) {
        $cacheManager->Delete('tccme_pkey_' . $userId);
        $cacheManager->Delete('tccme_cert_' . $userId);
      }
    }
    // decrpyt private key
    $privateKey = openssl_pkey_get_private($privateKey, $cryptKey);
    // get private key
    if (!@openssl_pkey_export($privateKey, $privateKey)) {
      PutLog(sprintf('Could not load private key for user #%d: %s', $userId, openssl_error_string()), PRIO_ERROR, __FILE__, __LINE__);
    }
    return $privateKey;
  }

  function getNotices()
  {
    global $lang_admin;

    if ($this->_hasQueue()) {
      return [
        0 => ['type' => 'info',
          'text' => $lang_admin['tccme.hinweis_warteschlange'],
          'link' => $this->_adminLink() . '&']
      ];
    }
    return [];
  }

  public function AdminHandler()
  {
    global $tpl, $lang_admin, $bm_prefs;

    if (!isset($_REQUEST['action'])) {
        $_REQUEST['action'] = 'start';
    }

    $tabs = [
      0 => ['title' => $lang_admin['overview'],
        'link' => $this->_adminLink() . '&amp;',
        'relIcon' => 'info32.png',
        'active' => $_REQUEST['action'] == 'start'],
      1 => ['title' => $lang_admin['prefs'],
        'link' => $this->_adminLink() . '&amp;action=settings&amp;',
        'relIcon' => 'ico_prefs_common.png',
        'active' => $_REQUEST['action'] == 'settings']
    ];

    $tpl->assign('tabs', $tabs);
    switch ($_REQUEST['action']) {
      case 'settings':
        $this->_adminSettings();
        break;
      default:
        $this->_adminStart();
    }
    $tpl->assign('pageURL', $this->_adminLink());
    $tpl->assign('tccme_name', $this->name);
    $tpl->assign('tccme_version', $this->version);
    $tpl->assign('tccme_prefs', $this->_getConfig());
    $tpl->assign('tpldir_user', B1GMAIL_REL . 'templates/' . $bm_prefs['template'] . '/');
  }

  private function _adminStart()
  {
    global $currentLanguage, $tpl, $db;

    if (isset($_REQUEST['do']) && $_REQUEST['do'] == 'workOffQueue') {
      if (!$this->_hasQueue()) {
        echo 'DONE';
      } else {
        echo $this->_workOffQueue();
      }
      exit;
    }

    $res = $db->Query("SELECT COUNT(*) FROM {pre}groupoptions WHERE `module` = ? AND `key` = 'tccme_eingeschaltet' AND `value` = 1 AND EXISTS (SELECT id FROM {pre}gruppen WHERE id = gruppe)", $this->internal_name);
    [$count] = $res->FetchArray(MYSQLI_NUM);
    $tpl->assign('tccme_groupCount', $count);
    $res->Free();

    $res = $db->Query('SELECT COUNT(*) FROM {pre}tccme_plugin_mail');
    [$count] = $res->FetchArray(MYSQLI_NUM);
    $tpl->assign('tccme_mailCount', $count);
    $res->Free();

    $tpl->assign('tccme_hasQueue', $this->_hasQueue());

    $tpl->assign('tccme_opensslSupport', SMIME_SUPPORT ? 'ok' : 'error');

    /*$queryURL = sprintf('%s?action=getLatestVersion&internalName=%s&b1gMailVersion=%s&js=1&language=%s&version=%s', $this->update_url, urlencode($this->internal_name), urlencode(B1GMAIL_VERSION), $currentLanguage, $this->version);
    $tpl->assign('updateURL', htmlspecialchars($queryURL));*/
    $tpl->assign('notices', $this->getNotices());
    $tpl->assign('page', $this->_templatePath('tccme.admin.start.tpl'));
  }

  function _hasQueue()
  {
    global $db;

    $res = $db->Query('SELECT id FROM {pre}tccme_plugin_queue WHERE finished != 1 LIMIT 1');
    $hasQueue = $res->FetchArray() !== false;
    $res->Free();
    return $hasQueue;
  }

  private function _adminSettings()
  {
    global $tpl, $db;

    if (isset($_REQUEST['do']) && $_REQUEST['do'] == 'save') {
      $db->Query('UPDATE {pre}tccme_plugin_settings SET
        schluessellaenge=?', $_REQUEST['schluessellaenge']);
    }
    $tpl->assign('page', $this->_templatePath('tccme.admin.settings.tpl'));
  }
}

/** register plugin */
$plugins->registerPlugin('TCMailEncryptionPlugin');

if (!class_exists('BMCache')) {
  include (B1GMAIL_DIR . 'serverlib/cache.class.php');
}

class TCMailEncryptionPlugin_BMCache_b1gMail extends BMCache_b1gMail
{
  function Add($key, $obj, $expires = 0)
  {
    if (substr($key, 0, 10) === 'parsedMsg:') {
      return (false);
    }

    return parent::Add($key, $obj, $expires);
  }
}

class TCMailEncryptionPlugin_BMCache_memcache extends BMCache_memcache
{
  function Add($key, $obj, $expires = 0)
  {
    if (substr($key, 0, 10) === 'parsedMsg:') {
      return (false);
    }

    return parent::Add($key, $obj, $expires);
  }
}
