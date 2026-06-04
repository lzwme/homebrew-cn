class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.37.0/bashunit"
  sha256 "18f1e8354213001b80e37c722b8520ebe26ce10fce11cb20ee471ddc96a21b11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af90dcaaa86b39168be3d32f3c458941cfcb987a5aa0a0737a3ddb2abf5540aa"
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