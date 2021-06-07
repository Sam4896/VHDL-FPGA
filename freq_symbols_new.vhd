library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned;
use ieee.numeric_std.all;
use ieee.std_logic_arith;
use work.input_data_type_package.all;


entity freq_symbols_new is
    Generic (
        input_data_width: integer :=1500
    );
    Port ( 
        clk :  in  std_logic;
        i_data_sent: in std_logic;
        out_ready: out std_logic; --output is ready
        in_ready: out std_logic; --ready to take input
        i_data: in input_data_type(input_data_width-1 downto 0);
        sym_freq_array_out: out sym_freq_type_integer --integer type
    );
end freq_symbols_new;

architecture arch of freq_symbols_new is

signal input_data: input_data_type(input_data_width-1 downto 0);

signal sym_freq_array: sym_freq_type_integer:= (others=>0);
signal input_data_integer: input_data_type_integer(input_data_width-1 downto 0) := (others=>0);

signal i_data_integer_ready: std_logic:='0';
signal freq_sym_complete: std_logic;

signal i_data_received: std_logic:='0';
signal freq_out_ready: std_logic;

begin

    inputdata: process(clk)
    begin
        if rising_edge(clk) then
            if i_data_sent='1' then --this if condition needs to be checked when connecting with the data source
                for i in 0 to input_data_width-1 loop
                    input_data(i)<=i_data(i);
                end loop;
                i_data_received<='1';
                sym_freq_array<= (others=>0);
            end if;
        end if;
    end process;
    
    input2integer: process(clk)
    begin
        if rising_edge(clk) then
            if i_data_received='1' and i_data_integer_ready='0' then
                for i in 0 to input_data_width-1 loop
                    input_data_integer(i) <= to_integer (unsigned(input_data(i)));
                end loop;
                i_data_integer_ready<='1';
                freq_sym_complete<='0';
            end if;
        end if;
    end process;
    
    
     symFreq: process(clk) 
     begin
        if rising_edge(clk) then
            if freq_sym_complete='0'and i_data_integer_ready ='1' then
                for j in 0 to input_data_width-1 loop
                    sym_freq_array(input_data_integer(j))<=sym_freq_array(input_data_integer(j))+1;
                end loop;
                freq_out_ready<='1';
            end if;
        end if;
     end process;
    
     process(clk)
     begin
        if rising_edge(clk) then
            if freq_out_ready = '1' then
                sym_freq_array_out<=sym_freq_array;
            end if;
        end if;
     end process; 

end arch;
