-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        11/13/2020
-- Objective:   Design an ALU
--              Opcode Output
--              0  0   1-bit shift left B
--              0  1   A - (B+2)
--              1  0   A / (B-1)
--              1  1   A + B

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- A input
        op : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Opcode
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- 7 bit decoded output.
        anode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    SIGNAL LED_BCD : STD_LOGIC_VECTOR (2 DOWNTO 0);
BEGIN

    anode <= "11111110"; -- AN0

    PROCESS (LED_BCD) BEGIN
        CASE LED_BCD IS
            WHEN "000" => seg <= "0000001"; -- "0"
            WHEN "001" => seg <= "1001111"; -- "1"
            WHEN "010" => seg <= "0010010"; -- "2"
            WHEN "011" => seg <= "0000110"; -- "3"
            WHEN "100" => seg <= "1001100"; -- "4"
            WHEN "101" => seg <= "0100100"; -- "5"
            WHEN "110" => seg <= "0100000"; -- "6"
            WHEN "111" => seg <= "0001111"; -- "7"
            WHEN OTHERS =>
        END CASE;
    END PROCESS;

    PROCESS (op, A, B) BEGIN

        -- 1-bit shift left B
        IF (op = "00") THEN
            LED_BCD <= STD_LOGIC_VECTOR(unsigned(B) SLL 1);
        END IF;

        -- A - (B+2)
        IF (op = "01") THEN
            LED_BCD <= A - (B + 2);
        END IF;

        -- A / (B-1)
        IF (op = "10") THEN
            LED_BCD <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(A)) / to_integer(unsigned(B - 1)), 3));
        END IF;

        -- A + B
        IF (op = "11") THEN
            LED_BCD <= A + B;
        END IF;

    END PROCESS;

END Behavioral;
