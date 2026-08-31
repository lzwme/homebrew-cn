class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "b81896e79ae12e24daf60b8addf7d38d9242ad411ce20b77257d763a03472868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75de12e9c578befb4513a0e8afd6b6dd3e262dd338018b68666a2e300b744d65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe65324d8d5b8959924d9e8554dc944471f301f478c764671b6db17a27689b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2914c507131a622aa5f16cd36c071cc03392e5233a5899471eeb2142f35984"
    sha256 cellar: :any,                 arm64_linux:   "18d56bba7166e3b07ff055729e45601653ddb5b646bd9aed298ba793fccf93d0"
    sha256 cellar: :any,                 x86_64_linux:  "c1e1f5284ba8eef60361d64c0f35304f00bcd6cda65a0ce9eda219ef2a1079bf"
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