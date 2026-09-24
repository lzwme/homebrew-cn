class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "8025dce319a520a8e48906fbbdb8377f297d1fffd9542d27141edf10741d90b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af488f4e0b1f5775e3d72b2f4d61c0f0423d36dd32ce86efae76e3e59971d28b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "016e22c18dd31444e93fad0d5a352e7c5cc0a036175da50d35fa9dc41230fad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db07cb28622bb8e7caf9524bea64bdf4737192360632b2ac5095c1a11eebbca2"
    sha256 cellar: :any,                 arm64_linux:       "463696742f82dbdf1099bb44e362a046f72ebf9d7d273dfab160454153b1c4f1"
    sha256 cellar: :any,                 x86_64_linux:      "c53c940719a0f7a61b7cb39ef0d2f3fb3236148763294294bc5c7ef3eb4fc997"
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