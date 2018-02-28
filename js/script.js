$(document).on('submit', '#withdrawal-form', function (e) {
	// Checking card number
	var $this = $(this),
		cardNumber = $this.find('#creditCardNumberHidden').val(),
		cardHolder = $this.find('#card-holder-name').val(),
		$submitBtn = $this.find('input[type=submit]'),
		reg = /^[a-zA-Z\.\- ]+$/;

	if ((cardNumber.length < 15) || (!valid_credit_card(cardNumber))) {
		// console.log(!valid_credit_card(cardNumber));
		alert("Заполните корректно номер карты!");
		return false;
	}

	disableCardNumberHelpers();
	$this = $this.serialize();
	showLoader();
	return true;
});

function sendMessage(status, data) {
	var message = {
		source: 'withdrawal',
		status: status,
		data: data
	};
	window.parent.postMessage(JSON.stringify(message), '*');
}

$(document).ready(function () {
	$('input[type=text]').keyup();
});

$(document).on('keyup', '#creditCardNumber', function () {
	if (window.event) {
		if (event.keyCode == 8 || event.keyCode == 39 || event.keyCode == 37) return; /// google chrome fix
	}
	var $this = $(this);
	$this.val(checkFocusNext($this.val()));
});

function checkFocusNext(value) {
	var pattern = /[^\d]+/g;
	value = value.replace(pattern, '');
	if (value.length <= 4) {
		value = value.slice(0, 4);
	} else if (value.length > 4 && value.length <= 8) {
		value = value.slice(0, 4) + ' ' + value.slice(4, 8);
	} else if (value.length > 8 && value.length <= 12) {
		value = value.slice(0, 4) + ' ' + value.slice(4, 8) + ' ' + value.slice(8, 12);
	} else if (value.length > 12) {
		value = value.slice(0, 4) + ' ' + value.slice(4, 8) + ' ' + value.slice(8, 12) + ' ' + value.slice(12, 16);
	}

	return value;
}

function valid_credit_card(value) {
	// accept only digits, dashes or spaces
	if (/[^0-9-\s]+/.test(value)) return false;

	// The Luhn Algorithm. It's so pretty.
	var nCheck = 0, nDigit = 0, bEven = false;
	value = value.replace(/\D/g, "");

	for (var n = value.length - 1; n >= 0; n--) {
		var cDigit = value.charAt(n),
			nDigit = parseInt(cDigit, 10);

		if (bEven) {
			if ((nDigit *= 2) > 9) nDigit -= 9;
		}

		nCheck += nDigit;
		bEven = !bEven;
	}

	return (nCheck % 10) == 0;
}

function showLoader() {
	$('.preloader').show();
}
function hideLoader() {
	$('.preloader').hide();
}

function disableCardNumberHelpers() {
	$('[data-card-type="cardNumber"]').each(function (index, item) {
		$(item).prop('disabled', true);
	});
}

function getCreditNumberVal() {
	var allNumberVal = '';

	$('[data-card-type="cardNumber"]').each(function (index, item) {
		allNumberVal += $(item).val();
	});

	return allNumberVal;
}

$(document).on('keyup', '[data-card-type="cardNumber"]', function (e) {
	var input = $(e.target),
		creditCardNumberHidden = $('#creditCardNumberHidden');

	creditCardNumberHidden.val(getCreditNumberVal());

	if (input.val().length === 4 || input.val().length > 3) {
		input.next().focus();
	} else if (input.val().length === 0 && e.key === "Backspace") {
		input.prev().focus();
	}
});

$(document).on('keydown', '[data-card-type="cardNumber"]', function (e) {
	var input = $(e.target);

	if (input.val().length > +input.attr('maxlength') - 1 && e.key !== "Backspace") {
		return false;
	}
});

$(document).ready(function () {
	$('input[type=text]').each(function (idx, el) {
		var textField = $(el),
			inputParent = textField.parent('.input');

		if (el.value.length > 0) {
			inputParent.addClass('active');
		}

		textField.on('input', function () {
			if (el.value.length > 0) {
				inputParent.addClass('active');
			} else if (el.value.length == 0) {
				inputParent.removeClass('active');
			}
		});

		textField.on('focus', function () {
			inputParent.addClass('active');
		});

		textField.on('blur', function () {
			if (el.value.length == 0) {
				inputParent.removeClass('active');
			}
		});
	});
});