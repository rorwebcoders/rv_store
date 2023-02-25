$(document).ready(function() {
    $('#contact_form').bootstrapValidator({        
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            fname: {
                validators: {
                        stringLength: {
                        min: 3,
                    },
                        notEmpty: {
                        message: '<span style="color:red;">Please enter your first name</span>'
                    }
                }
            },
             lname: {
                validators: {
                     stringLength: {
                        min: 3,
                    },
                    notEmpty: {
                        message: '<span style="color:red;">Please enter your last name</span>'
                    }
                }
            },
            email: {
                validators: {
                    notEmpty: {
                        message: '<span style="color:red;">Please enter your email address</span>'
                    },
                    emailAddress: {
                        message: '<span style="color:red;">Please enter a valid email address</span>'
                    }
                }
            },
            comment: {
                validators: {
                      stringLength: {
                        min: 10,
                        max: 200,
                        message:'Please enter at least 10 characters and no more than 200'
                    },
                    notEmpty: {
                        message: '<span style="color:red;">Please enter your message</span>'
                    }
                    }
                }
            }
        }).on('success.form.bv', function(e) {           
            e.preventDefault();            
            var $form = $(e.target);            
            $.post($form.attr('action'), $form.serialize(), function(result) {                
				$("#message").html(result.message).addClass('show');
				$("#contact_form").find("input[type=text], input[type=email], textarea").val("");
            }, 'json');
        });
});