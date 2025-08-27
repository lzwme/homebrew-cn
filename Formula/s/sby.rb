class Sby < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://ghfast.top/https://github.com/YosysHQ/sby/archive/refs/tags/v0.56.tar.gz"
  sha256 "988205ae899e0f13a14b0b3c504d815b764ea41b2f1547b31334f74f1a7b596b"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "18d6376f9bec6e09a8e29b126fb132efc13215c6b6b6649adb8f1d47e0b5b20e"
  end

  depends_on "yices2" => :test
  depends_on "python@3.13"
  depends_on "yosys"

  def install
    venv = virtualenv_create(libexec, "python3.13")
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