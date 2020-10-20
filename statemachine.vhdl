-- Author:      Dylan Richards
-- Class:       EGR 480
-- Date:        9/17/2020
-- Objective:   Sequence detector for detecting the sequence "1101"

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY seq_det IS
    PORT (
        clk : IN STD_LOGIC; -- PIN E3 is 100 MHz
        reset : IN STD_LOGIC;
        inBtn : IN STD_LOGIC; --input bit sequence  
        outInd : OUT STD_LOGIC; --'1' indicates the pattern "1101" is detected in the sequence.
        anode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        segment7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END seq_det;

ARCHITECTURE Behavioral OF seq_det IS
    TYPE state_type IS (s0, s1, s2, s3); --Defines the type for states in the state machine
    SIGNAL state : state_type := s0; --Declare the signal with the corresponding state type.
    SIGNAL count : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

    PROCESS (clk, reset)
    BEGIN
        anode <= "11111110";
        IF (reset = '1') THEN
            count <= (OTHERS => '0');
            outInd <= '0';
            state <= s0;
        ELSIF (rising_edge(clk)) THEN
            count <= count + 1;
            IF (count = 100000000) THEN
                count <= (OTHERS => '0');

                CASE state IS
                    WHEN s0 => --when the current state is s0
                        outInd <= '0';
                        IF (inBtn = '0') THEN
                            segment7 <= "0000001"; -- '0'
                            state <= s0;
                        ELSE
                            segment7 <= "1001111"; -- '1'
                            state <= s1;
                        END IF;
                    WHEN s1 => --when the current state is s1
                        outInd <= '0';
                        IF (inBtn = '0') THEN
                            segment7 <= "0000001"; -- '0'
                            state <= s0;
                        ELSE
                            segment7 <= "0010010"; -- '2'   
                            state <= s2;
                        END IF;
                    WHEN s2 => --when the current state is s2
                        outInd <= '0';
                        IF (inBtn = '0') THEN
                            segment7 <= "0000110"; -- '3'  
                            state <= s3;
                        ELSE
                            segment7 <= "0010010"; -- '2'   
                            state <= s2;
                        END IF;
                    WHEN s3 => --when the current state is s3   
                        IF (inBtn = '0') THEN
                            segment7 <= "0000001"; -- '0'
                            state <= s0;
                            outInd <= '0';
                        ELSE
                            segment7 <= "1111111"; -- 'ALL ON'   
                            state <= s1;
                            outInd <= '1'; --Output is 1 when the pattern "1101" is found in the sequence.
                        END IF;
                    WHEN OTHERS =>
                        NULL;
                END CASE;

            END IF;
        END IF;

    END PROCESS;
END Behavioral;
