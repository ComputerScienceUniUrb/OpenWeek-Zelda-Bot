<?php
/*
 * CodeMOOC TreasureHuntBot
 * ===================
 * UWiClab, University of Urbino
 * ===================
 * Basic message processing in pull mode for your bot.
 */

require_once(dirname(__FILE__) . '/lib.php');

// Reload latest update ID received (if any) from persistent store
$last_update = @file_get_contents("pull-last-update.txt");

// Fetch updates from API
// Note: we remember the last fetched ID and query for the next one, if available.
//       The third parameter enabled long-polling. Switch to any number of seconds
//       to enable (the request will hang until timeout or until a message is received).
$content = telegram_get_updates(intval($last_update) + 1, 1, 60);
if($content === false) {
    Logger::fatal('Failed to fetch updates from API');
}
if(count($content) == 0) {
    Logger::debug('No new messages');
    exit;
}

$first_update = $content[0];

Logger::debug('New update: ' . print_r($first_update, true));

// Updates have the following structure:
// [
//     {
//         "update_id": 123456789,
//         "message": {
//              ** message object **
//         }
//     }
// ]

$update_id = $first_update['update_id'];
$message = $first_update['message'];

// Update persistent store with latest update ID received
file_put_contents("pull-last-update.txt", $update_id);

if(!$message) {
    Logger::fatal('Non-message update received');
}

include 'msg_processing_core.php';
