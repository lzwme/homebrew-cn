class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.46.0/bashunit"
  sha256 "c49fd3874c7df68170f6a22d76599031113f2bb8a5a3bca664fa056dc214e85f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce28ec5ed756efa56af413e00c0e72f48e8159147550f943b9493fda9a82fab3"
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