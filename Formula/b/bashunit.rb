class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.45.0/bashunit"
  sha256 "19983f26299825ff26cfbb90e6b3b6e86fc8044168191d3e8b86f615313a80a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a7fbafd9b4aeee73752ca372c84725e6236ba9944aafd1a875d17a349cce325"
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