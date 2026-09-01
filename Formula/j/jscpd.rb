class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "f839cc8d8c6960bf204feaabe3c436fd98a8c6a6ca7a33e57c3dd4fb71fd162f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a92c9a173e015c7c16d1e891c1919cc91990006b15ac5154d82b112044667d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46dffb27948d477e7db2b1cc24ae492c0a61da9d35a110e13b182494780d0ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79827615d626bbfe0f0a2ea279b24ed5a23cb4fc31277ed0cb1b8e2f1d1e5392"
    sha256 cellar: :any,                 arm64_linux:   "d3fc3faca92711dd1779bd6f5dc7a51db22feeb97e6720875da141d56ca5c42b"
    sha256 cellar: :any,                 x86_64_linux:  "c61b678029632c3ff4ffdfa5e2806c16069a999a5be6a300a42cb289da49bd83"
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