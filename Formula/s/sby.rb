class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://ghfast.top/https://github.com/YosysHQ/sby/archive/refs/tags/v0.54.tar.gz"
  sha256 "9bc0df922dac71dae18f4a43db5a75da0e9c7b8800416f86cb62f94f4f2f98f9"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1538ac94e094c01dc3ad4f27632fe344969c12efd6ee479b86668ad61204103f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1538ac94e094c01dc3ad4f27632fe344969c12efd6ee479b86668ad61204103f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1538ac94e094c01dc3ad4f27632fe344969c12efd6ee479b86668ad61204103f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1538ac94e094c01dc3ad4f27632fe344969c12efd6ee479b86668ad61204103f"
    sha256 cellar: :any_skip_relocation, ventura:       "1538ac94e094c01dc3ad4f27632fe344969c12efd6ee479b86668ad61204103f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b6ad5de4a617d579d3b240f164864cd303bf4a64e1e6413a0c782450bf2577f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6ad5de4a617d579d3b240f164864cd303bf4a64e1e6413a0c782450bf2577f"
  end

  depends_on "yices2" => :test
  depends_on "python@3.13"
  depends_on "yosys"

  def install
    system "python3.13", "-m", "pip", "install", *std_pip_args(build_isolation: true), "click"
    system "make", "install", "PREFIX=#{prefix}"
    rewrite_shebang detected_python_shebang, bin/"sby"
  end

  test do
    (testpath/"cover.sby").write <<~EOF
      [options]
      mode cover

      [engines]
      smtbmc

      [script]
      read -formal cover.sv
      prep -top top

      [files]
      cover.sv
    EOF
    (testpath/"cover.sv").write <<~EOF
      module top (
        input clk,
        input [7:0] din
      );

      reg [31:0] state = 0;

      always @(posedge clk) begin
        state <= ((state << 5) + state) ^ din;
      end

      `ifdef FORMAL
        always @(posedge clk) begin
          cover (state == 'd 12345678);
          cover (state == 'h 12345678);
        end
      `endif
      endmodule
    EOF
    assert_match "DONE (PASS, rc=0)", shell_output("#{bin}/sby -f #{testpath}/cover.sby")
  end
end