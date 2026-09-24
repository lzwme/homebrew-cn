class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.14.tgz"
  sha256 "f74bd78902b6e83c4c488d6ea979c15619a11dbd0d8e21f4246bdd357c19c091"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "812ed56ff994d96c571d0fde3fe0a0e5a5776cda1d779d9569808e1687c55f34"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end