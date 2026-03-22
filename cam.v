// ============================================================================
// Module      : cam
// Description : Content Addressable Memory module.
//               Performs value-based lookup and outputs the corresponding
//               index. Supports write, search, delete, and reset operations.
//
// Highlights:
//   - Parameterizable depth, data width, and address size
//   - Each entry includes a validity flag
//   - Returns first matching index (priority to lowest index)
//   - Supports invalidating entries
//   - Provides full and empty status outputs
// ============================================================================

module cam #(
    parameter DEPTH      = 16,
    parameter WIDTH      = 8,
    parameter ADDR_WIDTH = 4
)(
    input  wire                  clk,
    input  wire                  rst,          // Active-high synchronous reset

    // Write interface
    input  wire                  we,           // Enables write operation
    input  wire [ADDR_WIDTH-1:0] waddr,        // Address to write into
    input  wire [WIDTH-1:0]      din,          // Input data

    // Delete interface
    input  wire                  delete_en,    // Clears entry at given address

    // Search interface
    input  wire                  search_en,    // Triggers search operation
    input  wire [WIDTH-1:0]      search_key,   // Value to be searched

    // Outputs
    output reg                   match,        // High when a match is detected
    output reg  [ADDR_WIDTH-1:0] match_index,  // Index of matched entry
    output reg                   busy,         // Indicates search completion

    // Status
    output wire                  full,         // Indicates memory is full
    output wire                  empty         // Indicates memory is empty
);

    // -------------------------------------------------------------------------
    // Storage arrays and validity indicators
    // -------------------------------------------------------------------------
    reg [WIDTH-1:0] mem   [0:DEPTH-1];
    reg             valid [0:DEPTH-1];

    // -------------------------------------------------------------------------
    // Tracks number of valid entries
    // -------------------------------------------------------------------------
    reg [ADDR_WIDTH:0] entry_count;

    assign full  = (entry_count == DEPTH);
    assign empty = (entry_count == 0);

    // -------------------------------------------------------------------------
    // Update entry count based on valid entries
    // -------------------------------------------------------------------------
    integer c;
    always @(posedge clk) begin
        if (rst) begin
            entry_count <= 0;
        end else begin
            // Count active entries every cycle
            entry_count <= 0;
            for (c = 0; c < DEPTH; c = c + 1)
                entry_count <= entry_count + valid[c];
        end
    end

    // -------------------------------------------------------------------------
    // Handles reset, write, and delete operations
    // -------------------------------------------------------------------------
    integer j;
    always @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < DEPTH; j = j + 1) begin
                mem[j]   <= {WIDTH{1'b0}};
                valid[j] <= 1'b0;
            end
        end else if (delete_en) begin
            valid[waddr] <= 1'b0;   // mark entry as invalid
        end else if (we) begin
            mem[waddr]   <= din;    // write data into memory
            valid[waddr] <= 1'b1;   // mark entry as valid
        end
    end

    // -------------------------------------------------------------------------
    // Search logic with priority to lowest index match
    // -------------------------------------------------------------------------
    integer i;
    reg found;  // temporary flag for match detection