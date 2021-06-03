module mealy_machine(
    input wire ain,
    output reg yout,
    input wire reset,
    input wire clk,
    output reg[3:0] countout
    );
    integer count=0;
    integer resetcounter =0;
    
    always @(posedge clk)
    begin
        if (reset)
            begin
            count = 0;
            countout=count;
            end
        else
            if (ain)
            begin
            count = count+1;;
            countout=count;
            end
    end
    always @(count)
    begin
        
        if (~reset)
            if (count%3==0)
                yout = 1'b1;
            else
                yout = 1'b0;
        else
            yout = 1'b0;
    end
endmodule

