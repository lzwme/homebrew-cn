class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.4.1.tgz"
  sha256 "9144f0e2a4cea7837a698aaf84291cb89a796ef2495b28cb339c90ae78c48751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b539d9aa53b4cfe39a58d98f67e410953377e4218b96a7db73a1dff56072a39"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end