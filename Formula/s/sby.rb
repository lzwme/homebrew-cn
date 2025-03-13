class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https:symbiyosys.readthedocs.ioenlatest"
  url "https:github.comYosysHQsbyarchiverefstagsv0.51.tar.gz"
  sha256 "7564ecf8420b088cbbe0c87d4bd20962f04ce157bea456e153de1f0f1bcb6db1"
  license "ISC"
  head "https:github.comYosysHQsby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19349780750bb29ff7e12546fa835372575e0fb08414dd801909a42dd2a6b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d19349780750bb29ff7e12546fa835372575e0fb08414dd801909a42dd2a6b54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d19349780750bb29ff7e12546fa835372575e0fb08414dd801909a42dd2a6b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "d19349780750bb29ff7e12546fa835372575e0fb08414dd801909a42dd2a6b54"
    sha256 cellar: :any_skip_relocation, ventura:       "d19349780750bb29ff7e12546fa835372575e0fb08414dd801909a42dd2a6b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1626456c18c14e6ecc2c7c49c53c7e6bacaf9dfcb6de95ea0f206c10738a8c4"
  end

  depends_on "yices2" => :test
  depends_on "python@3.13"
  depends_on "yosys"

  def install
    system "python3.13", "-m", "pip", "install", *std_pip_args(build_isolation: true), "click"
    system "make", "install", "PREFIX=#{prefix}"
    rewrite_shebang detected_python_shebang, bin"sby"
  end

  test do
    (testpath"cover.sby").write <<~EOF
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
    (testpath"cover.sv").write <<~EOF
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
    assert_match "DONE (PASS, rc=0)", shell_output("#{bin}sby -f #{testpath}cover.sby")
  end
end