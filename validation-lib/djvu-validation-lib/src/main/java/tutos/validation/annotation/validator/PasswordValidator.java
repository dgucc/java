package tutos.validation.annotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import tutos.validation.annotation.DjvuPassword;

import java.util.Objects;

public class PasswordValidator implements ConstraintValidator <DjvuPassword, String> {

    private int min;
    private boolean requiredUppercase;
    private boolean requiredLowercase;
    private boolean requiredDigit;
    private boolean requiredSpecial;


    @Override
    public void initialize(DjvuPassword annotation) {
        this.min = annotation.min();
        this.requiredUppercase = annotation.requiredUppercase();
        this.requiredLowercase = annotation.requiredLowercase();
        this.requiredDigit = annotation.requiredDigit();
        this.requiredSpecial = annotation.requiredSpecial();
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if(Objects.isNull(value) || value.isBlank()) return true;

        if (value.length() <= min) return false;

        boolean hasUppercase = false;
        boolean hasLowercase = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for(char c: value.toCharArray()) {
            if (Character.isWhitespace(c)) return false;
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
            }
            if (Character.isLowerCase(c)) {
                hasLowercase = true;
            }
            if (Character.isDigit(c)) {
                hasDigit = true;
            } else {
                hasSpecial = true;
            }
        }

        return (!requiredUppercase || hasUppercase)
                && (!requiredLowercase || hasLowercase)
                && (!requiredDigit || hasDigit)
                && (!requiredSpecial || hasSpecial);
    }
}
