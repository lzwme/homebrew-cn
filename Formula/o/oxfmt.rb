class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.23.0.tgz"
  sha256 "c4047cf33f0921441b13c7ff3b2c3e10004b484fe8f10c24ae2a85c2cf0ce852"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be21b0a2406eab2a23b6c372c11fe65e7283b012011a12b46da3821f97f92cad"
    sha256 cellar: :any,                 arm64_sequoia: "3c508fa76b334982c110f95307661cf50793eaa6103aa0511acbaa633b094239"
    sha256 cellar: :any,                 arm64_sonoma:  "3c508fa76b334982c110f95307661cf50793eaa6103aa0511acbaa633b094239"
    sha256 cellar: :any,                 sonoma:        "76db647126909098c18811e4ad28e1ab9b8f9172fb73c47380c6db6f55559c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbc7185d4ef047141b447a95b7fb6685d659162c3ff765ac16c83323f437b372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5ead9cde7a390a40500945611a933811560f5e327b5dd32b60b96e902ba6a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end