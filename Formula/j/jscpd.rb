class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "1d457dfac79e056825e3e45fd70356b4e36eef6bba20a88eea0397d13505cf9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13083c283f3e2cc9ad15c78e25396775bde3364d0ab8eff999237a55a22310bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd6c8438c507f64b87ad57addf5b682f5b79a3edf23a13273954e727c830f59b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cfec2a4549025a271bc6c75d2d22ce4dbc1ec65b9f3f68bff190e0a078dbf60"
    sha256 cellar: :any,                 arm64_linux:       "7ee919cff9b9e9cd8182f9e1bfb98f789934d277683408b66b4d37f72348e338"
    sha256 cellar: :any,                 x86_64_linux:      "4ef6cb663a8cbfdf68adc1290c2340a09d5d1cfb8e1317aca297ef0f1a97fa4d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/Cargo.toml"
  end

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