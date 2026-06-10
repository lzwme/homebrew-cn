class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.54.0.tgz"
  sha256 "c8ee361ba6cdad0606afc746f852a0286ce56bf77dc4143d34388741f2f388c2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c310fd72a5cdd50cd51d70838ed502f5cb43e03b6635657c99549ecff86a41c"
    sha256 cellar: :any,                 arm64_sequoia: "53dd310e540bb167b384b96447a45f9bbaf3a5c385b74e3445a0a3609effe1cf"
    sha256 cellar: :any,                 arm64_sonoma:  "53dd310e540bb167b384b96447a45f9bbaf3a5c385b74e3445a0a3609effe1cf"
    sha256 cellar: :any,                 sonoma:        "4b055d0497c6bf81128afc3b5fde64c6fd99dc981b195fb94d71f7939e2de80b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cba4a79602a81bf65fb74ce701e381458bd4cc40954c4526fd33e7a2d5d4aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7284d8c579cde99830d76c2baf455c5083f7c8de72f27d4b8a110df075939d4"
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