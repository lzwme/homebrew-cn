class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.10.tar.gz"
  sha256 "33576c5f4b74c2be06837b7db071e99072eec7d115b8e6fc347af2d22cbf24d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f61fab6d6242df0b41c7e3142bfea6b4e3acc0e1f972b3eb6d0d12abbb26848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a065e0f680f304f0cf8e91fa74191a8533af8e4f90f931c401c42cae55089cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94e8671eb0463ed022085a15654b823a7f238bf65c5c923cbe9831874281d36"
    sha256 cellar: :any_skip_relocation, sonoma:        "cafea290c43ea5f06398445200085528554b3bc783e97bbb3a5c9b9896ff8376"
    sha256 cellar: :any,                 arm64_linux:   "7e8653358acb929dcec3879214a50aecb15c775b06fd69d2f76a4ca27865995c"
    sha256 cellar: :any,                 x86_64_linux:  "91b5b16656beed72a16d534209188df99b33a24ba2d1aee1329580c9836d99e7"
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