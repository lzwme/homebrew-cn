class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "8a474c5fb920922e011e3facbe05be797e2c4849ba61d31a7cdef217f9b4daaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14745891e5a514bd5b4e6d3177cfa2bf076457dd88cb2631617ce37b1428b1da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e2c8e1fc6e5ba4deb25c752f7f7d5cbee057aa193eac811e13e837072031d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ef8b681a9153eea52b1edf88c1bbfa272852852381943b35f8e002e04509fdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "00620c1bb16d48618d92929b23a3aca0b533471e065cce153ada5aa1235eef08"
    sha256 cellar: :any,                 arm64_linux:       "81a551812fd9b5c44b65b90111b65cd2a760c247c09c6f41855487bf8d717f76"
    sha256 cellar: :any,                 x86_64_linux:      "26ce697faf8546dc76006abd434a47dede98cc1bf4d9633977300226d6329a90"
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