class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.41.0/bashunit"
  sha256 "146c9b1f5462633d40c377ab0548bbd1a720ce365f49ef6942621192b4d15f79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "113e6bc048c0b4d1e6a65788af4adb91cd767da06bd083e1c450cf069f769919"
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