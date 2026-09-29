class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "79eb83d76b56e5cd2ce21f1cc30d96fb4b7d084981716a124491f3eb09e89bef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "621884e96bdbe3253588cb2e6d91405130eae0fcecadd7121e9faa46366012f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cddcb52c9eee591c55b57ae6ce3b0b00baa835dac88cb66f6e23997ac673641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d709909d5052690f539fed38ba3fe89ed78fd790ad24f6af3b4a428af5bd6dc"
    sha256 cellar: :any,                 arm64_linux:       "067ccb55454725ebbd31e1d0e7445b9da7c7811b337f18cb8b52c60c6d55fedd"
    sha256 cellar: :any,                 x86_64_linux:      "8c1760804a3f20b85e725a1780845e71dabf1bd4141e7d46c0593ee37d587e07"
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