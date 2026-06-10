class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.39.1/bashunit"
  sha256 "0cb0153ebcf7198371051332b8e8fce36c47b514eef9bb362148f404837c2e82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf44988c0802d37611e90af442e3f581a174412e3707df3882538ad1d348fedf"
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