class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.23.0/bashunit"
  sha256 "7043c1818016f330ee12671a233f89906f0d373f3b2aa231a8c40123be5a222b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31c48c6a5a1c377d19e9a53bcc77e3528b8f738466b8c90195c1e8faf978b4a3"
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