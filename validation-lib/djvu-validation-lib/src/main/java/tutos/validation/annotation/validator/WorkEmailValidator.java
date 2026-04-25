package tutos.validation.annotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import tutos.validation.annotation.DjvuEmail;

import java.util.Objects;
import java.util.regex.Pattern;

public class WorkEmailValidator implements ConstraintValidator<DjvuEmail, String> {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]{3,}@demo.com$");

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if(Objects.isNull(value) || value.isBlank()) return true;

        var email = value.trim().toLowerCase();
        return EMAIL_PATTERN.matcher(value).matches();
    }
}
