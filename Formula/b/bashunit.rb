class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.43.0/bashunit"
  sha256 "151f3647964d53d3f5a7065c141790fc1b66ea3039024c80ed09b3a9602064a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63f0bad9afa5b347e5961b6144750a698e7184d91b485aa15c2693a12a86e114"
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