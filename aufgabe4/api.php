<?php
require_once 'config.php';
$tables = ['kunden', 'warenkorb', 'produkte', 'bestellung', 'hersteller'];

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$table = $_GET['tabelle'] ?? '';

if (!in_array($table, $tables)) {
    die("Invalid table name");
}
$sql = "SELECT * FROM `$table`";
$stmt = $conn->prepare($sql) or die("Prepare failed: " . $conn->error);
$stmt->execute();
$result = $stmt->get_result();

$rows = [];
while ($row = $result->fetch_assoc()) {
    $rows[] = $row;
}
echo json_encode($rows);
$conn->close();
?>
