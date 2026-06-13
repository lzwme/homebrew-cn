class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.8.tar.gz"
  sha256 "382f6792f6280e35318d1928e76a64ea3798428079a43cb3cd2528103948e9f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd360e97eb25e5ceae73f4976ff4fd7b444278487338cd7c162eefd77031ff1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5adde500a93031a190178198308960926e48f9a09fbcd18422d7ea84704f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade9dd5bffd2b684be888f181096613e71a1cb1664d57b95d4af43000cfd5fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1189c00609cd65abe515faab73e435bc977f6b32d5611326f247f2a8f5b45dbb"
    sha256 cellar: :any,                 arm64_linux:   "dacbcec9ffb05e83274b45e627a9b212a52198322e27012c984db673a341126b"
    sha256 cellar: :any,                 x86_64_linux:  "35132a7689b499b2164c140f88575c719cf38d4614af82f7d1ccd621d3a40147"
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