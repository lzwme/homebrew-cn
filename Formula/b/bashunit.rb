class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://ghfast.top/https://github.com/TypedDevs/bashunit/releases/download/0.30.0/bashunit"
  sha256 "1cdb44f844f8decf9943c2b8e18679b4497e3bd798ce4aa9605cfde3d357706f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4931cb22317a87a1a3d41db3ab7581630b7d3beb9dc97de4476b9fdfb56db6ad"
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