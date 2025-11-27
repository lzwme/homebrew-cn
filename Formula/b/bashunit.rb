class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.27.0/bashunit"
  sha256 "b9362d720a46eb600d42ba18e6944521822ca397d1eaa1d0240fca8ce3fb859d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e40103db93e1089fa018d4551183c84264c3b912dd887d7e60c8185fc0aec6bf"
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