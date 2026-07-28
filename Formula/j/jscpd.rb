class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.14.tar.gz"
  sha256 "c7a339017af0687e2f399d55216721376a0c24d88cce1efd9effb524ec96537a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a01bac1c72ab7a26b989c94f9496720e92b76752c3abca1005a9693f745bbb7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db63f51fef7eab4fe4ba86069e87f64d22b76a08020203dbded9aa277fb225f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b80bbad229ba5a4b39d9841acb82469d93adb800635c2c7412303dfb3ae449"
    sha256 cellar: :any_skip_relocation, sonoma:        "d770a0d4d61a3a909bd82147c774ed46f123d0bcf27d8f2898e431c5ad037b44"
    sha256 cellar: :any,                 arm64_linux:   "fa7bc9a6aee774966f961e24c74b643c0cd79c6830f15d9e8daf64ac5f56b452"
    sha256 cellar: :any,                 x86_64_linux:  "3b8cd507f5f93ff09fd1cb1a50fcabbd1c811b41dfa4aafc7f0d23dbd02d007e"
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