

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.math_real.all;

entity average is
    Port ( 
        clk :  in std_logic;
        avr: inout integer := 0
    );
end average;

architecture arch of average is

-- reg_stv is the 32 size 8 bit wide std_logic_vector to store the values
-- the values are updated in the vector with every rising edge of the clock
-- the average (avr) also updates with every rising edge of the clock


-- most of them are taken as variables so that we can obtain the result in the same clock cycle
-- only avr is taken as inout so it can be read and written too

type m_array_stv is array (32 downto 1) of std_logic_vector (7 downto 0);
shared variable reg_stv : m_array_stv;

shared variable reg_try: unsigned (7 downto 0);


shared variable rand_out : integer;
shared variable counter: integer :=1;
 
-- function to generate random integer value between the range of 0 to 255
shared variable seed1, seed2: integer :=999;
impure function rand_int(min_val, max_val: integer) return integer is
    variable r:real;
    begin
        uniform(seed1, seed2, r);
        return integer(r * real(max_val - min_val)  + real(min_val));
end function;
 

begin


process(clk)
begin
    if rising_edge(clk) then
        -- the random number is fed into the array
        rand_out := rand_int(min_val=>0,max_val=>255);
        if (counter < reg_stv'length+1) then
            reg_stv(counter):= conv_std_logic_vector(rand_out, reg_stv(counter)'length);
            
            -- new average is calculated for the updated value
            if (counter = 1) then
                reg_try := unsigned(reg_stv(counter));
                avr <= conv_integer(reg_try);
            else
                reg_try := unsigned(reg_stv(counter));
                avr <= (avr*(counter-1)+conv_integer(reg_try))/counter;
            end if;
            counter:=counter+1;  
        end if;
    end if;
    
end process;

end arch;
