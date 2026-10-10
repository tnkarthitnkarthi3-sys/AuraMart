
package com.auramart.security;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PasswordUtilTest {

    @Test
    void hashReturnsNullForNullInput() {
        assertNull(PasswordUtil.hash(null));
    }

    @Test
    void hashProduces64CharacterHexString() {
        String hash = PasswordUtil.hash("test-password");

        assertNotNull(hash);
        assertEquals(64, hash.length());
        assertTrue(PasswordUtil.looksHashed(hash));
    }

    @Test
    void samePasswordProducesSameHash() {
        assertEquals(
            PasswordUtil.hash("hello123"),
            PasswordUtil.hash("hello123")
        );
    }

    @Test
    void looksHashedRejectsPlainText() {
        assertFalse(PasswordUtil.looksHashed("hello123"));
        assertFalse(PasswordUtil.looksHashed(null));
    }
}
