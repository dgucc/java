package tutos.validation.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import tutos.validation.annotation.validator.PasswordValidator;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = PasswordValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface DjvuPassword {

    String message() default """
            Password must be at least 12 characters long and contain at least one uppercase letter, 
            one lowercase letter, one digit, one special character and no whitespace
            """;

    Class<?> [] groups() default {};

    Class<? extends Payload>[] payload() default {};

    int min() default 12;
    boolean requiredUppercase() default true;
    boolean requiredLowercase() default true;
    boolean requiredDigit() default true;
    boolean requiredSpecial() default true;

}
