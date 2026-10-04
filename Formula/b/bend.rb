class Bend < Formula
  desc "Language that blocks AI mistakes via proof"
  homepage "https://bend-lang.com"
  url "https://ghfast.top/https://github.com/bendlang/bend/archive/refs/tags/v2.0.35.tar.gz"
  sha256 "8d827520ce2cb75c79ed0603cf562a240ba511ab88a6f991ff334a7162c37fba"
  license "Apache-2.0"
  head "https://github.com/bendlang/bend.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2ee56a2434c8427e01fdeefaefad4710fb4b621162eeaa3495a36831a915594"
  end

  depends_on "bun"

  on_linux do
    depends_on "llvm"
  end

  deny_network_access!

  def install
    libexec.install "bend2", "guide"
    (bin/"bend").write_env_script formula_opt_bin("bun")/"bun", libexec/"bend2/main.ts", BEND_NO_TELEMETRY: "1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bend version")

    (testpath/"test.bend").write <<~BEND
      import Base

      def main() -> U32:
        (2 + 3 : U32)
    BEND
    assert_equal "5\n", shell_output("#{bin}/bend #{testpath}/test.bend")

    system bin/"bend", testpath/"test.bend", "-o", testpath/"test"
    assert_equal "5\n", shell_output(testpath/"test")
  end
end