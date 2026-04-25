package demo.validation;

import jakarta.validation.constraints.NotBlank;
import tutos.validation.annotation.DjvuEmail;
import tutos.validation.annotation.DjvuPassword;

public record LoginRequest(
        @NotBlank
        @DjvuEmail
        String email,
        @NotBlank
        @DjvuPassword(min=8,requiredDigit = false, requiredSpecial = false, message="Password must be at least 8 characters long")
        String password) {


}
