<?php
include 'header.php';

if (run_setup())
	run_create_board();

function run_create_board()
{
	define('INPUT_TEMPLATE', 'setup/create_board_file');
	define('SETUP_TEMPLATE', 'setup/create_board_template');
	
	echo '<div class="pad10">';
	
	echo 'Enter a list of words to make a wordsearch. The words can be seperated by space, dash, comma, underscore, or newlines.';
	
	echo '<form method="get" action=""><center><textarea name="words">' . (isset ($_GET['words']) ? $_GET['words'] : 'Put your words here.') . '</textarea>' .
			'<br /><input type="submit" value="Submit"></center></form>';

	if (isset ($_GET['words']))
	{
		// clean things up
		$words = preg_split("/[\s,.\-_\n]+/", $_GET['words']);
		foreach ($words as $key => $word)
		{
			$temp_word = trim($word);
			if (!empty ($temp_word))
				$words[$key] = $temp_word;
			else
				unset ($words[$key]);
		}
		$implode_words = '"' . implode('" "', $words) .'"';

		// then make our setup file
		$SETUP = do_replacement(ACL2_SRC_DIR . SETUP_TEMPLATE, array('list_words' => $implode_words));

		//output the words
		echo '<ul>';
		foreach ($words as $word)
			echo '<li>' . $word . '</li>';
		echo '</ul>';

		// run command
		// NOTE for now this uses redirected input, but it will eventually
		// use clay's ACL2 code
		$final_call = ACL2_EXE_DIR . ' < ' . $SETUP;
		echo '<p >Command: ' . $final_call . '</p>';
		exec($final_call, $console_log);
		
		foreach ($console_log as $key => $results)
		{
			if(starts_with($results, 'ACL2 p!>"[[') &&
				ends_with($results, ']]"'))
				{
					echo '<p id="board_json">';
					$json = '';
					
					//then just clean it
					$json = str_replace('ACL2 p!>"[[', '[["', $results);
					$json = str_replace(']]"', '"]]', $json);
					
					//first add back in our quotes
					$json = str_replace('],[', ';', $json);
					$json = str_replace(',', '","', $json);
					$json = str_replace(';', '"],["', $json);
									
					echo $json;
					
					echo '</p>';
					break;
				}
		}
		
		echo '<div id="acl2_output">';
		var_dump ($console_log);
		echo '</div>';

		echo '</div>';

		//delete setup
		//unlink($SETUP);
	}
}

function do_replacement($file_in, $replace_array)
{
	$data = file_get_contents($file_in . '.txt');

	// do tag replacements or whatever you want
	foreach($replace_array as $key => $value)
		$data = str_replace('{'.strtoupper($key) .'}', $value, $data);	
	
	//$data = str_replace('{WORDS}', $words, $data);
	$data = str_replace('{ACL2_SRC_DIR}', ACL2_SRC_DIR, $data);
	$data = str_replace('{ACL2_TEACHPACKS}', ACL2_TEACHPACKS, $data);

	//make a temp file
	$tmpfname = tempnam(sys_get_temp_dir(), 'acl');

	$handle = fopen($tmpfname, "w");
	fwrite($handle, $data);
	fclose($handle);

	return $tmpfname;
}

function run_setup()
{
	$running_local = false;
	if ($_SERVER['REMOTE_ADDR'] == '::1' || $_SERVER['REMOTE_ADDR'] == '127.0.0.1')
		$running_local = true;

	if ($running_local)
	{
		if (isset ($_COOKIE['ACL2_EXE_DIR']) && isset ($_COOKIE['ACL2_SRC_DIR']) && isset ($_COOKIE['ACL2_TEACHPACKS']))
		{
			if (file_exists($_COOKIE['ACL2_EXE_DIR']) && is_dir($_COOKIE['ACL2_SRC_DIR']) && is_dir($_COOKIE['ACL2_TEACHPACKS']))
			{
				//run with our commands
				set_directories($_COOKIE['ACL2_EXE_DIR'], $_COOKIE['ACL2_SRC_DIR'], $_COOKIE['ACL2_TEACHPACKS']);
				return true;
			}
			else
			{
				echo '<p>Problem with directories, try again.</p>';
				unset_directories();
			}
		}
		elseif (isset ($_POST['ACL2_EXE_DIR']) && isset ($_POST['ACL2_SRC_DIR']) && isset ($_POST['ACL2_TEACHPACKS']))
		{
			if (file_exists($_POST['ACL2_EXE_DIR']) && is_dir($_POST['ACL2_SRC_DIR']) && is_dir($_POST['ACL2_TEACHPACKS']))
			{
				//run with our commands
				set_directories($_POST['ACL2_EXE_DIR'], $_POST['ACL2_SRC_DIR'], $_POST['ACL2_TEACHPACKS']);
				return true;
			}
			else
			{
				echo '<p>Problem with directories, try again.</p>';
				unset_directories();
			}
		}

		//print a form to enter stuffs
		echo '<form method="post" action="">';
		echo '<span class="label">ACL2 EXE Directory</span><input type="text" name="ACL2_EXE_DIR" /><br />';
		echo '<span class="label">ACL2 SRC Directory</span><input type="text" name="ACL2_SRC_DIR" /><br />';
		echo '<span class="label">ACL2 Teachpacks</span><input type="text" name="ACL2_TEACHPACKS" /><br />';
		echo '<input type="submit" value="Submit"></form>';
	}
	else
	{
		// not running local, use preset directories
		$ACL2_EXE_DIR = 'C:/ACL2/run_acl2.exe';
		$ACL2_SRC_DIR = 'C:/Users/Jakob/Desktop/School/Spring2013/se/svn/src/';
		$ACL2_TEACHPACKS = 'C:/Users/Jakob/AppData/Roaming/Racket/planet/300/5.2.1/cache/cce/dracula.plt/8/23/teachpacks';

		set_directories($ACL2_EXE_DIR, $ACL2_SRC_DIR, $ACL2_TEACHPACKS);
		return true;
	}

	return false;
}

function set_directories($ACL2_EXE_DIR, $ACL2_SRC_DIR, $ACL2_TEACHPACKS)
{
	define('ACL2_EXE_DIR', $ACL2_EXE_DIR);
	define('ACL2_SRC_DIR', $ACL2_SRC_DIR);
	define('ACL2_TEACHPACKS', $ACL2_TEACHPACKS);

	set_cookies(time() + 36000);
}

function unset_directories()
{
	set_cookies(time() - 36000);
}

function set_cookies($time)
{
	setcookie('ACL2_EXE_DIR', ACL2_EXE_DIR, $time);
	setcookie('ACL2_SRC_DIR', ACL2_SRC_DIR, $time);
	setcookie('ACL2_TEACHPACKS', ACL2_TEACHPACKS, $time);
}

// thanks to http://stackoverflow.com/questions/834303/php-startswith-and-endswith-functions
function starts_with($haystack, $needle)
{
    return !strncmp($haystack, $needle, strlen($needle));
}

function ends_with($haystack, $needle)
{
    $length = strlen($needle);
    if ($length == 0) 
        return true;

    return (substr($haystack, -$length) === $needle);
}

include 'tailer.php';