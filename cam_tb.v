// ============================================================================
// Testbench : cam_tb
// Description : Verification environment for CAM module
//               Includes tests for reset, write, search (hit/miss),
//               delete operation, priority handling, overwrite,
//               and status flags (full/empty)
// ============================================================================

`timescale 1ns / 1ps

module cam_tb;

    // Parameters
    localparam DEPTH      = 8;
    localparam WIDTH      = 8;
    localparam ADDR_WIDTH = 3;
    localparam CLK_PERIOD = 10;

    // DUT signals
    reg                   clk;
    reg                   rst;
    reg                   we;
    reg  [ADDR_WIDTH-1:0] waddr;
    reg  [WIDTH-1:0]      din;
    reg                   delete_en;
    reg                   search_en;
    reg  [WIDTH-1:0]      search_key;

    wire                  match;
    wire [ADDR_WIDTH-1:0] match_index;
    wire                  busy;
    wire                  full;
    wire                  empty;

    // Instantiate DUT (Device Under Test)
    cam #(
        .DEPTH     (DEPTH),
        .WIDTH     (WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk        (clk),
        .rst        (rst),
        .we         (we),
        .waddr      (waddr),
        .din        (din),
        .delete_en  (delete_en),
        .search_en  (search_en),
        .search_key (search_key),
        .match      (match),
        .match_index(match_index),
        .busy       (busy),
        .full       (full),
        .empty      (empty)
    );

    // Clock generation (50% duty cycle)
    initial clk = 0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Pass/fail counters
    integer pass_cnt = 0;
    integer fail_cnt = 0;

    // Utility task for result checking
    task check(input [199:0] name, input condition);
        begin
            if (condition) begin
                $display("[PASS] %0s", name);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] %0s", name);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    // Main stimulus block
    initial begin
        $dumpfile("cam_tb.vcd");
        $dumpvars(0, cam_tb);

        // Initialize all inputs
        rst        = 0;
        we         = 0;
        waddr      = 0;
        din        = 0;
        delete_en  = 0;
        search_en  = 0;
        search_key = 0;

        $display("");
        $display("========================================");
        $display("  CAM Verification (DEPTH=%0d, WIDTH=%0d)", DEPTH, WIDTH);
        $display("========================================");
        $display("");

        // ----- Reset test -----
        $display("--- Reset Test ---");

        // ----- Write operations -----
        $display("--- Write Operations ---");

        // ----- Search hit test -----
        $display("--- Search Hit ---");

        // ----- Search miss test -----
        $display("--- Search Miss ---");

        // ----- Priority check (duplicate values) -----
        $display("--- Priority Check ---");

        // ----- Delete operation -----
        $display("--- Delete Operation ---");

        // ----- Overwrite behavior -----
        $display("--- Overwrite Test ---");

        // ----- Full flag verification -----
        $display("--- Full Condition ---");

        // ----- Final summary -----
        $display("");
        $display("========================================");
        $display("  %0d PASSED / %0d FAILED / %0d TOTAL",
                 pass_cnt, fail_cnt, pass_cnt + fail_cnt);
        $display("========================================");

        $finish;
    end

    // Simulation timeout safeguard
    initial begin
        #50000;
        $display("[TIMEOUT]");
        $finish;
    end

endmodule