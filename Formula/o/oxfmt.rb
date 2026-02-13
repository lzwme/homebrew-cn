class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.32.0.tgz"
  sha256 "0f9a8ff49d9770a119ce6aaf990f5e223d1750707909552bb7fda93e87786026"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8176d3788905ec19482de2dc730ab0339c00d8172d386af07464597bda9520c7"
    sha256 cellar: :any,                 arm64_sequoia: "2575c5f5c71b2c21cb09296c8376caf882b692c6b36dd36b40f802dd907054ee"
    sha256 cellar: :any,                 arm64_sonoma:  "2575c5f5c71b2c21cb09296c8376caf882b692c6b36dd36b40f802dd907054ee"
    sha256 cellar: :any,                 sonoma:        "f5aa5b70a2ba67ab3e6d8bf3d598bda1343462f40a15a06564a15b0a4621727b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe129fac45cf0c7e2a76979e066ca0a243b83b4f2b58edff81449a4218d863d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fe8b6a6819fe786b9d1ab0713c35a7d6e3292ba1a2029cc7592953392b608c6"
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