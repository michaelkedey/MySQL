<?php

// Replace these values with your actual database credentials
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "iridis assets tracker";

// Create a connection to the database
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Function to sanitize input data
function sanitizeInput($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

// Initialize variables for form data and success message
$name = $position = $deviceType = $deviceSerialNumber = $model = $iridisNumber = $acquisitionDate = $initialCondition = $reasonForAcquisition = $approvingAuthority = $returnDate = $returnCondition = $employeesSignature = $employeesContact = $successMessage = "";

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Sanitize and retrieve form data
    $name = sanitizeInput($_POST["Name"]);
    $position = sanitizeInput($_POST["Position"]);
    $deviceType = sanitizeInput($_POST["DeviceType"]);
    $deviceSerialNumber = sanitizeInput($_POST["DeviceSerialNumber"]);
    $model = sanitizeInput($_POST["Model"]);
    $iridisNumber = sanitizeInput($_POST["IridisNumber"]);
    $acquisitionDate = sanitizeInput($_POST["AcquisitionDate"]);
    $initialCondition = sanitizeInput($_POST["InitialCondition"]);
    $reasonForAcquisition = sanitizeInput($_POST["ReasonForAcquisition"]);
    $approvingAuthority = sanitizeInput($_POST["ApprovingAuthority"]);
    $returnDate = sanitizeInput($_POST["ReturnDate"]);
    $returnCondition = sanitizeInput($_POST["ReturnCondition"]);
    $employeesSignature = sanitizeInput($_POST["EmployeesSignature"]);
    $employeesContact = sanitizeInput($_POST["EmployeesContact"]);

    // SQL query to insert data into the database
    $sql = "INSERT INTO tracking_register (Name, Position, Device_type, Device_serial_number, Device_model, Iridis_number, Acquisition_date, Initial_condition, Reason_for_acquisition, Approving_authority, Return_date, Return_condition, Employees_contact, Employees_signature)
            VALUES ('$name', '$position', '$deviceType', '$deviceSerialNumber', '$model', '$iridisNumber', '$acquisitionDate', '$initialCondition', '$reasonForAcquisition', '$approvingAuthority', '$returnDate', '$returnCondition', '$employeesContact', '$employeesSignature')";

    if ($conn->query($sql) === TRUE) {
        $successMessage = "Record inserted successfully";
    } else {
        $successMessage = "Error: " . $sql . "<br>" . $conn->error;
    }

    // Close the database connection
    $conn->close();
}
