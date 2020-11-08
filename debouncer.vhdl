-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        11/7/2020
-- Objective:   Debounce input D

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY debouncer IS
    PORT (
        D : IN STD_LOGIC;
        CLK : IN STD_LOGIC; -- 100 MHz E3
        Q : OUT STD_LOGIC := '0'
    );
END debouncer;

ARCHITECTURE Behavioral OF debouncer IS
    SIGNAL five_clock_counter : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
BEGIN

    PROCESS (CLK)
    BEGIN
        IF(rising_edge(CLK)) THEN 
            IF (D = '1') THEN
                IF (five_clock_counter < x"4") THEN
                    five_clock_counter <= five_clock_counter + x"1";
                ELSE
                    five_clock_counter <= five_clock_counter - x"2";
                    Q <= '1';
                END IF;
            ELSE
                IF (five_clock_counter < x"5") THEN
                    five_clock_counter <= five_clock_counter + x"1";
                ELSE
                    five_clock_counter <= (OTHERS => '0');
                    Q <= '0';
                END IF;
            END IF;
        END IF;
        
    END PROCESS;

END Behavioral;

