class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.47.0/bashunit"
  sha256 "defa50ff54c902acf33c17a2813a879defb349452b51f667736800e63c0156ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "773eb79557ef5f272d1c47d7314fcea84367c8e0fc9cee197a91b1512f0a5f81"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end