package tutos.validation.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import tutos.validation.annotation.validator.WorkEmailValidator;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = WorkEmailValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface DjvuEmail {

    String message() default "Please use a valide Business email";

    Class<?> [] groups() default {};

    Class<? extends Payload>[] payload() default {};

}
