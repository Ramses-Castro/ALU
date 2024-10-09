module ALU #(
  parameter WIDTH = 3
)(
  input [WIDTH-1:0] in1, in2,       // Entradas A y B de la ALU (in1 e in2)
  input [1:0] op,                   // Código de operación
//  input invalid_data,               // Señal para datos inválidos
  output reg [2*WIDTH-1:0] out,     // Salida de la ALU (doble ancho)
  output reg zero,                  // Señal de resultado cero (flag zero)
  output reg error                  // Señal de error (flag error división por cero o datos inválidos)
);

// Definición de operaciones para el selector
localparam SUM = 2'b00;
localparam SUB = 2'b01;
localparam MUL = 2'b10;
localparam DIV = 2'b11;

always @(*) begin
  // Inicializar flags de error y zero en 0
  error = 0;
  zero = 0;
  
//  if (invalid_data) begin
//    error = 1;  // Error si los datos son inválidos
//    out = {(2*WIDTH){1'b1}}; // Forzar salida a ser -1 (todos 1's)
//  end else 
  begin
    case (op)
      SUM: begin
        out = in1 + in2;
      end
      SUB: begin
        out = in1 - in2;
      end
      MUL: begin
        out = in1 * in2;
      end
      DIV: begin
        if (in2 == 0) begin
          error = 1;  // Error si se intenta dividir por 0
          out = {(2*WIDTH){1'b1}}; // Forzar salida a ser -1 (todos 1's)
        end else begin
          out = in1 / in2;
        end
      end
      default: begin
        error = 1;  // Activar error si la operación no es válida
        out = {(2*WIDTH){1'b1}}; // Forzar salida a ser -1 (todos 1's)
      end
    endcase
  end
  
  // Activar la señal zero si el resultado es 0
  if (out == 0) begin
    zero = 1;
  end
end

endmodule
