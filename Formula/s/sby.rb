class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https:symbiyosys.readthedocs.ioenlatest"
  url "https:github.comYosysHQsbyarchiverefstagsv0.49.tar.gz"
  sha256 "199bbba310089f42ac4705ecf0d2e26e1e671ae661c6240c7e795f05af1325b9"
  license "ISC"
  head "https:github.comYosysHQsby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b81884bc7bf026ab188ebcca1e2b714a4deae8f739a90bd9a4c43d5b31175e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b81884bc7bf026ab188ebcca1e2b714a4deae8f739a90bd9a4c43d5b31175e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b81884bc7bf026ab188ebcca1e2b714a4deae8f739a90bd9a4c43d5b31175e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b81884bc7bf026ab188ebcca1e2b714a4deae8f739a90bd9a4c43d5b31175e9"
    sha256 cellar: :any_skip_relocation, ventura:       "0b81884bc7bf026ab188ebcca1e2b714a4deae8f739a90bd9a4c43d5b31175e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "491f3ac4bf3697b25388f152cbcfd9d78c572cddb3acd850cb451305d5cfea11"
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