package com.auramart.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public final class PasswordUtil {

    private PasswordUtil() {
    }

    public static String hash(String password) {

        if (password == null) {
            return null;
        }

        try {

            MessageDigest digest =
                    MessageDigest.getInstance("SHA-256");

            byte[] hash =
                    digest.digest(
                            password.getBytes(
                                    StandardCharsets.UTF_8
                            )
                    );

            StringBuilder hex = new StringBuilder();

            for (byte b : hash) {
                hex.append(
                        String.format("%02x", b)
                );
            }

            return hex.toString();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Unable to hash password",
                    e
            );
        }
    }

    public static boolean looksHashed(String password) {

        if (password == null) {
            return false;
        }

        return password.matches(
                "^[a-fA-F0-9]{64}$"
        );
    }
}
