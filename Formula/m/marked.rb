class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.1.tgz"
  sha256 "998d979863cd0bd03597e7d3fc776de27cca8963d86d7842e5dd8188aa2edf22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce31ee8df1fdc7194f7856ec088b27856685ce374254951ca5c969b14cc35250"
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