-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        10/20/2020
-- Objective:   Use 8 seven segment displays to output the following based on 2 switches
--              A B Output
--              0 0 Display Your Favorite Date
--              0 1 Display Your Favorite Number
--              1 0 Display Your Favorite Color
--              1 1 Display Your Favorite Holiday

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY exam1 IS
    PORT (
        clk : IN STD_LOGIC; -- 100 MHz E3
        a : IN STD_LOGIC; -- A input
        b : IN STD_LOGIC; -- B input
        z : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- Z output state
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- 7 bit decoded output.
        anode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END exam1;

ARCHITECTURE Behavioral OF exam1 IS
    SIGNAL LED_BCD : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL refresh_counter : STD_LOGIC_VECTOR (19 DOWNTO 0);
    SIGNAL LED_activating_counter : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL displayed_number : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN

    PROCESS (LED_BCD) BEGIN
        CASE LED_BCD IS
            WHEN "0000" => seg <= "0000001"; -- "0"
            WHEN "0001" => seg <= "1001111"; -- "1"
            WHEN "0010" => seg <= "0010010"; -- "2"
            WHEN "0011" => seg <= "0000110"; -- "3"
            WHEN "0100" => seg <= "1001100"; -- "4"
            WHEN "0101" => seg <= "0100100"; -- "5"
            WHEN "0110" => seg <= "0100000"; -- "6"
            WHEN "0111" => seg <= "0001111"; -- "7"
            WHEN "1000" => seg <= "0000000"; -- "8"
            WHEN "1001" => seg <= "0000100"; -- "9"
            WHEN "1010" => seg <= "0110000"; -- E
            WHEN "1011" => seg <= "0000010"; -- A
            WHEN "1100" => seg <= "0001111"; -- T (11001101)
            WHEN "1101" => seg <= "0111001"; -- T (11001101)
            WHEN "1110" => seg <= "0001000"; -- R
            WHEN "1111" => seg <= "1111111"; -- OFF
            WHEN OTHERS =>
        END CASE;
    END PROCESS;

    PROCESS (clk) BEGIN
        IF (rising_edge(clk)) THEN
            refresh_counter <= refresh_counter + 1;
        END IF;
    END PROCESS;

    LED_activating_counter <= refresh_counter(19 DOWNTO 17);

    PROCESS (LED_activating_counter) BEGIN
        CASE LED_activating_counter IS
            WHEN "000" =>
                anode <= "01111111"; -- AN7
                LED_BCD <= displayed_number(31 DOWNTO 28); -- the first digit
            WHEN "001" =>
                anode <= "10111111"; -- AN6
                LED_BCD <= displayed_number(27 DOWNTO 24); -- the second digit
            WHEN "010" =>
                anode <= "11011111"; -- AN5
                LED_BCD <= displayed_number(23 DOWNTO 20); -- the third digit
            WHEN "011" =>
                anode <= "11101111"; -- AN4
                LED_BCD <= displayed_number(19 DOWNTO 16); -- the fourth digit
            WHEN "100" =>
                anode <= "11110111"; -- AN3
                LED_BCD <= displayed_number(15 DOWNTO 12); -- the fith digit
            WHEN "101" =>
                anode <= "11111011"; -- AN2
                LED_BCD <= displayed_number(11 DOWNTO 8); -- the sixth digit
            WHEN "110" =>
                anode <= "11111101"; -- AN1
                LED_BCD <= displayed_number(7 DOWNTO 4); -- the seventh digit
            WHEN "111" =>
                anode <= "11111110"; -- AN0
                LED_BCD <= displayed_number(3 DOWNTO 0); -- the eighth  digit
            WHEN OTHERS =>
        END CASE;
    END PROCESS;

    PROCESS (a, b) BEGIN

        --Fav Date (06/02/2020)
        IF (a = '0' AND b = '0') THEN
            z <= "00";
            displayed_number <= "00000110000000100010000000100000";
        END IF;

        -- Fav Number (18)
        IF (a = '0' AND b = '1') THEN
            z <= "01";
            displayed_number <= "11111111111111111111111100011000";
        END IF;

        -- Fav color (RED)
        IF (a = '1' AND b = '0') THEN
            z <= "10";
            displayed_number <= "11111111111111111111111010100000";
        END IF;

        -- Fav Holiday (EASTER)
        IF (a = '1' AND b = '1') THEN
            z <= "11";
            displayed_number <= "11111010101101011100110110101110";
        END IF;

    END PROCESS;

END Behavioral;
