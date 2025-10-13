class Sby < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://ghfast.top/https://github.com/YosysHQ/sby/archive/refs/tags/v0.58.tar.gz"
  sha256 "c3436712b2922a0698aa735f94fd0ea6dc4df3a3f31fcc2003eea15d68c55475"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8dd5d6bd0ab2d9c3ac030dca982a6243b42aa27a5098ac3c0dd16edbd88889f2"
  end

  depends_on "yices2" => :test
  depends_on "python@3.14"
  depends_on "yosys"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install "click"

    system "make", "install", "PREFIX=#{prefix}"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), bin/"sby"

    # Build an `:all` bottle
    return unless OS.mac?

    inreplace bin/"sby",
              "release_version = 'SBY '",
              "release_version = 'SBY v#{version}'"
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