class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.52.0.tgz"
  sha256 "3ceff3d2f6d61484975d275afa7585f328cfb0ea3acc5975a6b1416f35d22e93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bf49553c6138cb9a274f1ebb785615a9b4f793706fa4948c6a59fb59a74ff12"
    sha256 cellar: :any,                 arm64_sequoia: "844af3eb7f863cf99faa2cd94fe0bae62f9c78946a8c01872605e2ba5292356e"
    sha256 cellar: :any,                 arm64_sonoma:  "844af3eb7f863cf99faa2cd94fe0bae62f9c78946a8c01872605e2ba5292356e"
    sha256 cellar: :any,                 sonoma:        "55e620716b814111079532dc4b6a35e1a9d3836f4f195e68d1fdd9e7beb26dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "485ec5e003b20bc8b117b00949786860a26209bb69c671c934974558d3195558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a688ffc0de566c7ed42a3bf3ffad4096abd8741b99fd0b53f7bdcf45f2920b75"
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