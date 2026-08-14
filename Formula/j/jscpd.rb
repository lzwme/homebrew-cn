class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.15.tar.gz"
  sha256 "1796750a330412904294b5036a31677e670b596117c5986f1091a5b889ec348b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4fc40e007f4dd8eca62b2333eaf172164bc10044d4185ba82fbcf6ce3386a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b15fcd1fb8a5255999d79805358a094f176e2f5520b651e55057a89817a7f007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40fe883cc42847bc1cdf6c2d13f5909a4cf9a5be67534a123a6ad7fe58720bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9800df169fc74c6ad1ce6770a824fa9c08ef2fea697e55cc67bbc03013affc18"
    sha256 cellar: :any,                 arm64_linux:   "2a241f98087dcc38dc794b4ac8a5dc0d7d94b324569c7a245cbfdef682624cd1"
    sha256 cellar: :any,                 x86_64_linux:  "e7c8c817f0cd6debaa23a10ebb216f681d6584db0a8cd375afd4773854b3aba7"
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