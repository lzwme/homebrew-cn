class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.29.0/bashunit"
  sha256 "90d5afc07222920777d6c47af657d1d7a80a0055eaaa506c9c814f6b224da102"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dde7081aa0423669d8ee77ff284c8730a4a123874c346afc5971fd7d42390e41"
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