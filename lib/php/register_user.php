<?php
	if (!isset($_POST['register'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
		die();
	}

include_once("database.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);
$address = "na";
$credit = 20;

$sqlregister = "INSERT INTO `tbl_user`(`user_email`, `user_name`, `user_password`, `user_phone`, `user_address`, `user_otp`, `user_credit`) VALUES ('$email','$name','$password','$phone','$address',$otp, $credit)";

try {
	if ($conn->query($sqlregister) === TRUE) {
		$response = array('status' => 'success', 'data' => null);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
}
catch(Exception $e) {
  $response = array('status' => 'failed', 'data' => null);
  sendJsonResponse($response);
}
$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>