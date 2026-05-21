/**
 * Contact form validation & submit (page-contact.html)
 * reCAPTCHA v3 — client-side token only
 */
(function ($) {
	"use strict";

	var RECAPTCHA_V3_SITE_KEY = "6LdlyvUsAAAAADnXESJOBd88po84L_FMnMT0Wmx6";

	var $form = $("#contact_form");
	if (!$form.length || typeof $.fn.validate !== "function") return;

	var $alert = $("#form-result");
	var $captchaError = $("#captcha-error");
	var $recaptchaInput = $("#g-recaptcha-response");

	function showAlert(type, message) {
		if (!$alert.length) return;
		$alert
			.removeClass("contact-form-alert--success contact-form-alert--error")
			.addClass("contact-form-alert--" + type + " is-visible")
			.text(message);
	}

	function hideAlert() {
		if ($alert.length) {
			$alert.removeClass("is-visible contact-form-alert--success contact-form-alert--error").text("");
		}
	}

	function getRecaptchaV3Token(action) {
		return new Promise(function (resolve, reject) {
			if (typeof grecaptcha === "undefined" || typeof grecaptcha.ready !== "function") {
				reject(new Error("recaptcha_not_loaded"));
				return;
			}
			grecaptcha.ready(function () {
				grecaptcha
					.execute(RECAPTCHA_V3_SITE_KEY, { action: action || "contact_submit" })
					.then(resolve)
					.catch(reject);
			});
		});
	}

	function submitFormAjax(form) {
		var $submitBtn = $(form).find('button[type="submit"]');
		var loadingText = $submitBtn.data("loading-text") || "Sending…";
		var originalHtml = $submitBtn.html();
		$submitBtn.prop("disabled", true).html(loadingText);

		$(form).ajaxSubmit({
			dataType: "json",
			clearForm: false,
			success: function (data) {
				if (data && data.status === "true") {
					showAlert("success", data.message || "Thank you! Your inquiry was sent successfully. We will respond within one business day.");
					form.reset();
					$form.find(".form-control").removeClass("is-valid is-invalid").attr("aria-invalid", "false");
					$form.find(".field-error").empty();
					if ($recaptchaInput.length) $recaptchaInput.val("");
				} else {
					showAlert("error", (data && data.message) || "Something went wrong. Please try again or email info@acesoft.ca.");
				}
			},
			error: function () {
				showAlert("error", "Unable to send your message right now. Please try again or contact us at info@acesoft.ca.");
			},
			complete: function () {
				$submitBtn.prop("disabled", false).html(originalHtml);
			}
		});
	}

	$.validator.addMethod(
		"phoneIntl",
		function (value, element) {
			if (this.optional(element)) return true;
			var digits = value.replace(/\D/g, "");
			return digits.length >= 10 && digits.length <= 15;
		},
		"Enter a valid phone number (at least 10 digits)."
	);

	$.validator.addMethod(
		"noOnlyWhitespace",
		function (value, element) {
			return this.optional(element) || /\S/.test(String(value));
		},
		"This field cannot be blank or spaces only."
	);

	$form.validate({
		ignore: ":hidden:not(select)",
		errorElement: "span",
		errorClass: "field-error-msg",
		validClass: "valid",
		errorPlacement: function (error, element) {
			var $slot = element.closest(".contact-field").find(".field-error");
			error.addClass("field-error-msg");
			if ($slot.length) {
				$slot.html(error);
			} else {
				error.insertAfter(element);
			}
		},
		highlight: function (element) {
			$(element).addClass("is-invalid").removeClass("is-valid").attr("aria-invalid", "true");
		},
		unhighlight: function (element) {
			$(element).removeClass("is-invalid").addClass("is-valid").attr("aria-invalid", "false");
			$(element).closest(".contact-field").find(".field-error").empty();
		},
		rules: {
			name: {
				required: true,
				minlength: 2,
				maxlength: 80,
				noOnlyWhitespace: true
			},
			email: {
				required: true,
				email: true,
				maxlength: 120
			},
			subject: {
				required: true
			},
			phone: {
				phoneIntl: true,
				maxlength: 24
			},
			message: {
				required: true,
				minlength: 20,
				maxlength: 5000,
				noOnlyWhitespace: true
			}
		},
		messages: {
			name: {
				required: "Please enter your full name.",
				minlength: "Name must be at least 2 characters.",
				maxlength: "Name cannot exceed 80 characters."
			},
			email: {
				required: "Please enter your work email.",
				email: "Please enter a valid email address."
			},
			subject: {
				required: "Please select a project type."
			},
			message: {
				required: "Please describe your AI project requirements.",
				minlength: "Please provide at least 20 characters so we can understand your needs.",
				maxlength: "Message cannot exceed 5000 characters."
			}
		},
		submitHandler: function (form) {
			hideAlert();
			$captchaError.removeClass("is-visible").addClass("d-none");

			getRecaptchaV3Token("contact_submit")
				.then(function (token) {
					if ($recaptchaInput.length) {
						$recaptchaInput.val(token);
					}
					submitFormAjax(form);
				})
				.catch(function () {
					$captchaError.removeClass("d-none").addClass("is-visible");
					$captchaError
						.find(".captcha-error-text")
						.text("Security check could not run. Refresh the page and try again.");
				});

			return false;
		}
	});

	$form.on("input change", ".form-control", function () {
		if ($alert.hasClass("is-visible")) hideAlert();
	});

	$form.on("reset", function () {
		hideAlert();
		$captchaError.addClass("d-none").removeClass("is-visible");
		$form.find(".form-control").removeClass("is-valid is-invalid").attr("aria-invalid", "false");
		$form.find(".field-error").empty();
		if ($recaptchaInput.length) $recaptchaInput.val("");
	});
})(jQuery);
