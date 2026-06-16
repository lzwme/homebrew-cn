class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.9.tar.gz"
  sha256 "7928d686ef6a58aa191dc1b5a2a1c31e93e98956075207a9161f2f971d1ad97f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f1b0749921fec1c07a57da17f9da7e82bba642530ba56ff34d3208934a1c6ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6044cacd5f71b416bc4e14e4097d63a0a622dd95bc59d8f0bfbfbc8cdbb0a604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f398f64dd2555ce0018b0527e1d2b036f3c6be42263116567518488476e9698"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c73b7a9282bab3af6a4082b3e6bfcdaac28f6afaf4735c0b53ce78a81932d5"
    sha256 cellar: :any,                 arm64_linux:   "3776f6695a53ba970aca0bd5d90542dbf0b834593c04b7bb8516e64c91c4247e"
    sha256 cellar: :any,                 x86_64_linux:  "48a761e8638b7bcedb20733c5fb0161566947b9d87d25bd6d23a7ba9d577fc10"
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