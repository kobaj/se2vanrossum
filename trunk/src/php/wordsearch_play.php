<?php
$action = (isset ($_REQUEST['action']) ? $_REQUEST['action'] : '');

switch ($action)
{
	#============================================================
	# Default
	#============================================================
	default :
		$json = array (
			'success' => false
		);
		//code here
		//filter_input(INPUT_GET, 'the_table', FILTER_SANITIZE_STRING);
		echo json_encode($json);
		exit (0);
		break;

	case 'check_letter' :
		$json = array (
			'success' => false
		);
		
		if (isset ($_COOKIE['ACL2_EXE_DIR']) && isset ($_COOKIE['ACL2_SRC_DIR']) && isset ($_COOKIE['ACL2_TEACHPACKS']))
		{
			if (file_exists($_COOKIE['ACL2_EXE_DIR']) && is_dir($_COOKIE['ACL2_SRC_DIR']) && is_dir($_COOKIE['ACL2_TEACHPACKS']))
			{
				// set our directories				
				define('ACL2_EXE_DIR', $_COOKIE['ACL2_EXE_DIR']);
				define('ACL2_SRC_DIR', $_COOKIE['ACL2_SRC_DIR']);
				define('ACL2_TEACHPACKS', $_COOKIE['ACL2_TEACHPACKS']);
		
				define('SETUP_TEMPLATE', 'setup/check_board_template');
		
				$x = filter_input(INPUT_GET, 'x', FILTER_SANITIZE_STRING);
				$y = filter_input(INPUT_GET, 'y', FILTER_SANITIZE_STRING);
				$letter = filter_input(INPUT_GET, '', FILTER_SANITIZE_STRING);
				$solution = filter_input(INPUT_GET, 'x', FILTER_SANITIZE_STRING);
				
				// then make our setup file
				$SETUP = do_replacement(ACL2_SRC_DIR . SETUP_TEMPLATE, array('x' => $x,
																			 'y' => $y,
																			 'letter' => $letter,
																			 'solution' => $solution));
																			 
				$final_call = ACL2_EXE_DIR . ' < ' . $SETUP;
				exec($final_call, $console_log);
																	 
				var_dump ($console_log);
				
				//unlink($SETUP);
			}
		}
		
		echo json_encode($json);
		exit (0);
		break;
}

include 'magic_file_builder.php';
?>