<?php
/**
 * PHP script for downloading remote fonts in CSS files generated by Google Fonts.
 *
 * @package     Google Fonts Downloader
 * @version     1.0.0
 * @author      Edi Amin <to.ediamin@gmail.com>
 * @license     http://opensource.org/licenses/gpl-2.0.php GPL v2 or later
 * @link        https://github.com/ediamin/google-fonts-downloader
 */

require_once 'downloader.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Google Web Fonts Downloader</title>
	<style>
		html {
			font-family: sans-serif;
			-webkit-text-size-adjust: 100%;
			-ms-text-size-adjust:     100%;
		}

		body {
			margin: 0;
		}

		.container {
			width: 800px;
			margin: 20px auto 0;
		}

		input {
			border: 1px solid #AEAEAE;
			-webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,.07);
			box-shadow: inset 0 1px 2px rgba(0,0,0,.07);
			background-color: #fff;
			color: #333;
			outline: 0;
			-webkit-transition: .05s border-color ease-in-out;
			transition: .05s border-color ease-in-out;
			padding: 3px 8px;
			font-size: 16px;
			line-height: 100%;
			height: 1.7em;
			width: 100%;
			outline: 0;
			margin: 0;
			background-color: #fff;
		}

		button {
			display: inline-block;
			text-decoration: none;
			font-size: 13px;
			line-height: 26px;
			height: 28px;
			margin: 0;
			padding: 0 10px 1px;
			cursor: pointer;
			border-width: 1px;
			border-style: solid;
			-webkit-appearance: none;
			-webkit-border-radius: 3px;
			border-radius: 3px;
			white-space: nowrap;
			-webkit-box-sizing: border-box;
			-moz-box-sizing: border-box;
			box-sizing: border-box;
			border-color: #ccc;
			-webkit-box-shadow: inset 0 1px 0 #fff,0 1px 0 rgba(0,0,0,.08);
			box-shadow: inset 0 1px 0 #fff,0 1px 0 rgba(0,0,0,.08);
			vertical-align: top;
			background: #fafafa;
			color: #222;
		}
		
	</style>
</head>

<body>
	<div class="container">
		<?php if ( !empty( $msg ) ): ?>
		<p>Done!</p>
		<?php endif; ?>
		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
			<input type="text" name="link" value="<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700,300' rel='stylesheet' type='text/css'>">
			<p><button type="submit">Download</button></p>
		</form>
	</div>
</body>
</html>