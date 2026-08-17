class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.49.0/bashunit"
  sha256 "85e6f6ec564fb4b7611d61a219fec470350fde9ccc1ee7c77528cf0af9f766bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fd173103a12f719d7e41cac47cf8cb234a311145da157fc4e28a36ef81d6cd7"
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