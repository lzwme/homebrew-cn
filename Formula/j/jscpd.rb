class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "89a9963d2a947e55cd5287e84fd1b211b6b956b8cff9e4d5abad5d913900360d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37394ce209acc1236c0e3d6ec93493ea6d28141d16a5b511d2bd05d64fbe8d85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e894ff9546a1e5e141b50eb6c695c474947ca45776ed671df47361245efbe8ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8b536d91b4598698b3a9d591f25fc07999af4b3ffbea96c8bd552f1a92fa861"
    sha256 cellar: :any,                 arm64_linux:       "e1c4e18c251069c42ae320a42261b49de75b2f6ee962436907c52177a3fc5a82"
    sha256 cellar: :any,                 x86_64_linux:      "b2734041c4572d9a9e576b7f14c24cb240054161afa918141b9cdb87300399bf"
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