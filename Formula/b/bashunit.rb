class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.48.0/bashunit"
  sha256 "9e27d930a505fcdc46e0c3275ca943d412e5df4b51dc1f5b5219d794d3b1893d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dbd07be31fa47e2d36a4b2ad633afa110042f16de2bc61a6bcd4cb97ab2b557b"
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