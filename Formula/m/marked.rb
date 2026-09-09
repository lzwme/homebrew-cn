class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.12.tgz"
  sha256 "50f7134d0f110b3db6137ac269e6a45a79b3f8cf2b902c363f4c7dd5e2afece7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5cab13d824638ec761228570b937656f391333c81bbf696985081962a427c2a"
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