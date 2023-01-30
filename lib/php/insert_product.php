<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("database.php");
	$userid = $_POST['userid'];
    $prname= ucwords(addslashes($_POST['prname']));
	$prdesc= ucfirst(addslashes($_POST['prdesc']));
	$prprice= $_POST['prprice'];
    $qty= $_POST['qty'];
    $state= addslashes($_POST['state']);
    $local= addslashes($_POST['local']);
    $lat= $_POST['lat'];
    $lon= $_POST['lon'];
    $addr= $_POST['addr'];
    $image= $_POST['image'];
	
	$sqlinsert = "INSERT INTO `tbl_products`(`user_id`, `product_name`, `product_desc`, `product_price`, `product_qty`, `product_state`, `product_local`, `product_lat`, `product_lng`, `product_addr) VALUES ('$userid','$prname','$prdesc',$prprice,$delivery,$qty,'$state','$local','$lat','$lon', '$addr')";
	
  try {
		if ($conn->query($sqlinsert) === TRUE) {
			$decoded_string = base64_decode($image);
			$filename = mysqli_insert_id($conn);
			$path = '../assets/productimages/'.$filename.'.png';
			file_put_contents($path, $decoded_string);
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
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
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>
