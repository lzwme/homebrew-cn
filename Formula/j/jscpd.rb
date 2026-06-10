class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "dfaf2e068e20d14ebd50db45650dce8616059c070b375a978244f64400bd600d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "523cc86bc1f2d67a7a98957f74791bb272a03ff1061527edd2b478c2d6552ec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b395fc01b22791ffc91f8a29f037582d7dfd37015731faee9fd8d8294d5d7f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dab1d9b15b97c6f07e75b78724aa207942cbe25b4ddfbe2c8b3cc2f7f5ee401"
    sha256 cellar: :any_skip_relocation, sonoma:        "013d3fe1255c79457bcc951f61d80d749056e14ab00481d64594ebe81de2e536"
    sha256 cellar: :any,                 arm64_linux:   "01eb9515219300ac846b5fb9ae69e512872bd425071d2ad11a3b71b640d88651"
    sha256 cellar: :any,                 x86_64_linux:  "94de9a7012d24493d878a036adebe0bc8b32330f10317d188d67240dbe3ec1ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cpd")
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~JAVASCRIPT
      console.log("Hello, world!");
    JAVASCRIPT
    test_file2.write <<~JAVASCRIPT
      console.log("Hello, brewtest!");
    JAVASCRIPT

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end