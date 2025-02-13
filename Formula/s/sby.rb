class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https:symbiyosys.readthedocs.ioenlatest"
  url "https:github.comYosysHQsbyarchiverefstagsv0.50.tar.gz"
  sha256 "e538809f527628010830b2bbc450863c41617181972f3ab183728a6ab3194255"
  license "ISC"
  head "https:github.comYosysHQsby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "376d2144b6d49b7a8e9dc940ff49f991d9e8fc47626f9ee1d8030715937e8a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "376d2144b6d49b7a8e9dc940ff49f991d9e8fc47626f9ee1d8030715937e8a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "376d2144b6d49b7a8e9dc940ff49f991d9e8fc47626f9ee1d8030715937e8a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "376d2144b6d49b7a8e9dc940ff49f991d9e8fc47626f9ee1d8030715937e8a95"
    sha256 cellar: :any_skip_relocation, ventura:       "376d2144b6d49b7a8e9dc940ff49f991d9e8fc47626f9ee1d8030715937e8a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6039a94b53fec50e67c6e94f691a8ba58ecd9acc5631c1379b421416961033a"
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