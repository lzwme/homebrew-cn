class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "c29dda5e09bc8d75a8c352ba801e70599782acd8e51ca5dff8037f2f3e46a1c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "264a38eeed978562c8a5d612401074fbafd7db111f8565d52245391c94bec659"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5c7fbe810b5c00bd089aaeee54d37654c849e7c4e2f82185776578c3abe517c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc266cd001feccd6a587826ea01cb7f30b5906708442d58a89d6fbac463d2b03"
    sha256 cellar: :any,                 arm64_linux:       "ae9186df79a239d37ee5c3b4afa739a546eb0d8707778a548c014deec8c427c3"
    sha256 cellar: :any,                 x86_64_linux:      "b40c53dff460ca73617c653456fe079534cd4884c7af6536621630d2752b03f4"
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