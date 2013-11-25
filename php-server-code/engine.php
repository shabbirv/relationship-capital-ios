<?php

ini_set('allow_url_fopen', 'ON');
define('SERVER', 'db503573437.db.1and1.com');
define('USERNAME', 'dbo503573437');
define('PASSWORD', '');
define('DATABASE', 'db503573437');

class RCEngine {

	private $connection;
	private $pushClient;
	
	
	public function __construct() {
		//Connect to MySQL
		$connection = @mysql_connect(SERVER, USERNAME, PASSWORD) or die('Connection error -> ' . mysql_error());
        mysql_select_db(DATABASE, $connection) or die('Database error -> ' . mysql_error());
        $this->connection = $connection;
	}
	
	
	public function add_comment($comment, $user_id, $commitment_id) {
		$sql = mysql_query("INSERT INTO comment (text, user_id, commitment_id) VALUES ('$comment', '$user_id', '$commitment_id')");
		print json_encode(array('result'=>'0', 'reason'=>'Success'));
	}
	
	public function get_comments($commitment_id) {
		$sql = mysql_query("SELECT * FROM comment WHERE commitment_id='$commitment_id'");
		$array = array();
		while ($c = mysql_fetch_assoc($sql)) {
			$user_id = $c['user_id'];
			$c['user'] = $this->get_user($user_id);
			$array[] = $c;
		}
		print json_encode($array);
	}
	
	private function get_user($user_id) {
		$sql = mysql_query("SELECT * FROM user WHERE id='$user_id'");
		$user = mysql_fetch_assoc($sql);
		if (!$user) {
			$json = file_get_contents("http://it-376-api.herokuapp.com/api/v1/users");
			$json = json_decode($json, true);
			foreach ($json['users'] as $u) {
				$user = $u['user'];
				$name = $user['first_name'] . ' ' . $user['last_name'];
				$id = $user['id'];
				$email = $user['email'];
				$sql = mysql_query("INSERT INTO user (id, name, email) VALUES ('$id', '$name', '$email')");
			} 
		} else {
			return $user;
		}
		$sql = mysql_query("SELECT * FROM user WHERE id='$user_id'");
		$user = mysql_fetch_assoc($sql);	
		return $user;		
		
	}
}