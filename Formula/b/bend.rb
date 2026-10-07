class Bend < Formula
  desc "Language that blocks AI mistakes via proof"
  homepage "https://bend-lang.com"
  url "https://ghfast.top/https://github.com/bendlang/bend/archive/refs/tags/v2.0.36.tar.gz"
  sha256 "cbcd6f4b75897a05065872efac9b8d43595a467118331461eb1b92429b9e1689"
  license "Apache-2.0"
  head "https://github.com/bendlang/bend.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c866f353116a2fc017f123baf88b772dec52b555beb77f698ef73e7a5060900"
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