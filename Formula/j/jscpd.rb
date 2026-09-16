class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "902f07f7ebc3ff7c546b8533424a05176d29bab4539dbcc447c4815fc47c8136"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa0266fbe61763ee27f5c3662cc9ab8b5df3b23b0d12a424975304b35fc41b0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3efa2d9af0f640a1a3a143044bb274e3740b9dbd8156cfaaee2cfea2cced5451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf571b464e3bf25ebb8fd7c68535068f7f6e1c5d9f7cd86997d73af7869040e0"
    sha256 cellar: :any,                 arm64_linux:       "bc859f30aaf87994862ee247720dc77aa3dc11cf6f998164d3e8265829262e40"
    sha256 cellar: :any,                 x86_64_linux:      "76eb7f5aa901d12d9bcf6b265714d60c3a7ff9987bfcddfcf92c06c7cedd2b63"
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