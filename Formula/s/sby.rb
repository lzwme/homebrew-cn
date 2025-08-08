class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://ghfast.top/https://github.com/YosysHQ/sby/archive/refs/tags/v0.56.tar.gz"
  sha256 "988205ae899e0f13a14b0b3c504d815b764ea41b2f1547b31334f74f1a7b596b"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78bfffdccf6ecdf7810d134880eb5abcaac9ab38af6dbe315df846caa88b6f90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78bfffdccf6ecdf7810d134880eb5abcaac9ab38af6dbe315df846caa88b6f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78bfffdccf6ecdf7810d134880eb5abcaac9ab38af6dbe315df846caa88b6f90"
    sha256 cellar: :any_skip_relocation, sonoma:        "78bfffdccf6ecdf7810d134880eb5abcaac9ab38af6dbe315df846caa88b6f90"
    sha256 cellar: :any_skip_relocation, ventura:       "78bfffdccf6ecdf7810d134880eb5abcaac9ab38af6dbe315df846caa88b6f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9860ebf9d3c2bb36945a3207c53890ca66407d498ba08069c5c4f07ed7ec33ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9860ebf9d3c2bb36945a3207c53890ca66407d498ba08069c5c4f07ed7ec33ac"
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