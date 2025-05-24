class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https:bashunit.typeddevs.com"
  url "https:github.comTypedDevsbashunitreleasesdownload0.19.1bashunit"
  sha256 "2d085bcb752a9b910db7a964b309a25960a19e778f40676ff51d9d7534891a48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fe3ba4162a8e12f16a4e4cd328095cdb4933b446edc705527a16a7dadcde4ba"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}bashunit --version")
  end
end