-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        9/24/2020
-- Objective:   Simulate a D latch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY dlatch IS
    PORT (
        D : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        Q : OUT STD_LOGIC
    );
END dlatch;

ARCHITECTURE Behavioral OF dlatch IS

BEGIN
    PROCESS (CLK, D)
    BEGIN
        IF (CLK = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END Behavioral;
