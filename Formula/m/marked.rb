class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.6.tgz"
  sha256 "ea01608bbbbce475bfbd166f68ecb39c51dc4015744f64587c49dd4cf9cda1f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c36b144ecbc9278f63504007f11adea30f8093b929dfeb5936d1459240c2c21"
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