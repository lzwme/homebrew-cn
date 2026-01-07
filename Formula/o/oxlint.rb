class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.38.0.tgz"
  sha256 "6d3dc3934a2c2d26f2a0a24e0930cc8b1f86e180eecc46bf534f2de5190a3aa2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e794633e24dc99af101760d0a28b7d58bc1e5b2ea4a67168c29832d2798cfcb"
    sha256 cellar: :any,                 arm64_sequoia: "b6feff46278860d8c428a1fffbe545fa4ae449cbaf278562a0cd2f0c2f19479b"
    sha256 cellar: :any,                 arm64_sonoma:  "b6feff46278860d8c428a1fffbe545fa4ae449cbaf278562a0cd2f0c2f19479b"
    sha256 cellar: :any,                 sonoma:        "0b372e7615c72fe978b47f22939db9a2edafb46f4884dd05db727b92441ebbe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "881a2d5d32bbdf2da283d6525ff877ccfaa400d51f3ef49a08ff1e42ede0a902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2c9a4f332a2a654fc8fe8ef468d18c8bf56c7886c802c46c70896b2f9b0dd9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end