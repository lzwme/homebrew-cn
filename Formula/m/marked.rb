class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.11.tgz"
  sha256 "cef55476c7551e73e1a89118fa69fee9f7eef9960e9c774ad266e22ee966b994"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee5f83a54c9e274f9bd79c38c7dcb2e77cdab41470317e7903de321857eb90b8"
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