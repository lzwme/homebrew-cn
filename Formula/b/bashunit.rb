class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https:bashunit.typeddevs.com"
  url "https:github.comTypedDevsbashunitreleasesdownload0.13.0bashunit"
  sha256 "6d9f1b49e4cf61d9837277251cce566eaa8b73e0f417474949a48336bd43a901"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2bc31b114027161d266ce5de753b57692412fd684e7aba61010d416a1ca0cc61"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath"test.sh").write <<~EOS
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    EOS
    assert "addition", shell_output("#{bin}bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}bashunit --version")
  end
end