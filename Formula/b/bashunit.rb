class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https:bashunit.typeddevs.com"
  url "https:github.comTypedDevsbashunitreleasesdownload0.10.1bashunit"
  sha256 "c042dcac3ab63bd66cd6f5648d2eb21396437796f6583d4e100d7cd2d7c243e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c7fbf41e59d36d448d0cc3b727082339c9950dd8cec501ae860203f203f1471"
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