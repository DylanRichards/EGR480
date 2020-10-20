-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        9/24/2020
-- Objective:   Simulate a D flip-flop

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY dflipflop IS
    PORT (
        D : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        Q : OUT STD_LOGIC
    );
END dflipflop;

ARCHITECTURE Behavioral OF dflipflop IS

BEGIN
    PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN
            Q <= D;
        END IF;
    END PROCESS;
END Behavioral;
