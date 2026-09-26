class Bend < Formula
  desc "Language that blocks AI mistakes via proof"
  homepage "https://bend-lang.com"
  url "https://ghfast.top/https://github.com/bendlang/bend/archive/refs/tags/v2.0.28.tar.gz"
  sha256 "de196674ff9a9c231ca57767a88629fb71055ce1992dd3f557946404eb10d339"
  license "Apache-2.0"
  head "https://github.com/bendlang/bend.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "600d42aa5bf8a62a10ef397d4673fa697ad21be6d36cff5b0ab48de1f9030100"
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