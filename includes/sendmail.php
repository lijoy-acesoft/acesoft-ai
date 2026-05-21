<?php
header('Content-Type: application/json; charset=utf-8');

function contact_json_response($ok, $message, $httpCode = 200) {
	http_response_code($httpCode);
	echo json_encode([
		'status' => $ok ? 'true' : 'false',
		'message' => $message
	]);
	exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
	contact_json_response(false, 'Invalid request method.', 405);
}

$name = isset($_POST['name']) ? trim(strip_tags($_POST['name'])) : '';
$email = isset($_POST['email']) ? trim($_POST['email']) : '';
$subject = isset($_POST['subject']) ? trim(strip_tags($_POST['subject'])) : '';
$phone = isset($_POST['phone']) ? trim(strip_tags($_POST['phone'])) : '';
$message = isset($_POST['message']) ? trim(strip_tags($_POST['message'])) : '';
$botcheck = isset($_POST['form_botcheck']) ? trim($_POST['form_botcheck']) : '';

$errors = [];

if ($botcheck !== '') {
	contact_json_response(false, 'Unable to submit form. Please try again.', 400);
}

if ($name === '' || strlen($name) < 2 || strlen($name) > 80) {
	$errors[] = 'Please enter a valid full name (2–80 characters).';
}

if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($email) > 120) {
	$errors[] = 'Please enter a valid email address.';
}

$allowedSubjects = [
	'AI Strategy & Discovery',
	'LLM Apps, RAG & Copilots',
	'AI Agents & Automation',
	'Generative AI Development',
	'Machine Learning / MLOps',
	'AI Chatbot Development',
	'AI Staffing / Team Augmentation',
	'Other AI Project'
];

if ($subject === '' || !in_array($subject, $allowedSubjects, true)) {
	$errors[] = 'Please select a valid project type.';
}

if ($phone !== '') {
	$digits = preg_replace('/\D+/', '', $phone);
	if (strlen($digits) < 10 || strlen($digits) > 15) {
		$errors[] = 'Please enter a valid phone number (at least 10 digits).';
	}
}

if ($message === '' || strlen($message) < 20 || strlen($message) > 5000) {
	$errors[] = 'Please describe your project (20–5000 characters).';
}

if (!empty($errors)) {
	contact_json_response(false, implode(' ', $errors), 422);
}

$to = 'jim.jacob@acesoft.ca';
$mailSubject = 'NOT SPAM - Acesoft AI Development Lead | ' . $subject;
$body = "Name: $name\n"
	. "Email: $email\n"
	. "Project type: $subject\n"
	. "Phone: " . ($phone !== '' ? $phone : 'Not provided') . "\n\n"
	. "Message:\n$message\n";
$headers = "From: $name <" . $email . ">\r\n"
	. "Reply-To: " . $email . "\r\n"
	. "Content-Type: text/plain; charset=UTF-8";

if (@mail($to, $mailSubject, $body, $headers)) {
	contact_json_response(true, 'Thank you! Your inquiry was sent successfully. Our AI team will respond within one business day.');
}

contact_json_response(false, 'Failed to send your message. Please try again later or email info@acesoft.ca directly.', 500);
