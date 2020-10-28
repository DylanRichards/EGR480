-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        10/27/2020
-- Objective:   Count up and down by a switch and display on 7 segment

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter IS
    PORT (
        clk : IN STD_LOGIC; -- 100 MHz E3
        a : IN STD_LOGIC; -- Up/Down input
        z : OUT STD_LOGIC; -- Z output state
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- 7 bit decoded output.
        anode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END counter;

ARCHITECTURE Behavioral OF counter IS
    SIGNAL LED_BCD : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL one_second_counter : STD_LOGIC_VECTOR (27 DOWNTO 0);
    SIGNAL one_second_enable : STD_LOGIC;
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
            WHEN "1010" => seg <= "0000010"; -- a
            WHEN "1011" => seg <= "1100000"; -- b
            WHEN "1100" => seg <= "0110001"; -- C
            WHEN "1101" => seg <= "1000010"; -- d
            WHEN "1110" => seg <= "0110000"; -- E
            WHEN "1111" => seg <= "0111000"; -- F
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

    PROCESS (clk) BEGIN
        IF (rising_edge(clk)) THEN
            IF (one_second_counter >= x"5F5E0FF") THEN
                one_second_counter <= (OTHERS => '0');
            ELSE
                one_second_counter <= one_second_counter + "0000001";
            END IF;
        END IF;
    END PROCESS;

    one_second_enable <= '1' WHEN one_second_counter = x"5F5E0FF" ELSE '0';

    PROCESS (clk, a) BEGIN
        IF (rising_edge(clk) AND one_second_enable = '1') THEN
            z <= a;

            -- Count Down
            IF (a = '0') THEN
                displayed_number <= displayed_number - x"0001";
            END IF;

            -- Count Up
            IF (a = '1') THEN
                displayed_number <= displayed_number + x"0001";
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
