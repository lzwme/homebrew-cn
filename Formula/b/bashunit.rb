class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.31.0/bashunit"
  sha256 "a674f92ff2e44b905a0bcb00944ac35e89cdce0d2a6074c2eb829976116b0c9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2eeeeb14e340ba775d2408cf70655f7efb40ca23042c8f501155290a9eebb240"
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