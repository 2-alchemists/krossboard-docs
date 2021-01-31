var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};
$('#reply-message').html(getUrlParameter('message').replace(/\+/g, ' '));
$('#reply-message').attr('class', getUrlParameter('status'))


function validateEmail(email) {
    let re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

function validateForm() {
    isValid = true

    const name = $('#name').val();
    if (name.trim() === "") {
        $('#name').attr('class', 'error')
        isValid = false;
    } else {
        $('#name').attr('class', 'success')
    }

    const email = $('#email').val();
    if (! validateEmail(email)) {
        $('#email').attr('class', 'error')
        isValid = false;
    } else {
        $('#email').attr('class', 'success')
    }
    
    const organization = $('#organization').val();
    if (organization.trim() === "") {
        $('#organization').attr('class', 'error')
        isValid = false;
    } else {
        $('#organization').attr('class', 'success')
    }

    const subject = $('#subject').val();
    if (subject.trim() === "") {
        $('#subject').attr('class', 'error')
        isValid = false;
    } else {
        $('#subject').attr('class', 'success')
    }
    
    const message = $('#message').val();
    if (message.trim() === "") {
        $('#message').attr('class', 'error')
        isValid = false;
    } else {
        $('#message').attr('class', 'success')
    }

    if (! isValid) {
        $('#reply-message').html("please fix fields with error");
        $('#reply-message').attr('class', 'error')
    } else {
        document.getElementById('contact-form').submit();
        $('#reply-message').html("");
        $('#reply-message').attr('class', 'success')
    }

    return isValid
}


function recaptchaCallback(token) {
    document.getElementById('btnSubmit').disabled = false;
}
