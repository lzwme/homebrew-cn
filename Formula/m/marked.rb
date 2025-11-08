class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.0.tgz"
  sha256 "c69931ee3765bfc8ce62d8d3fe1b54a2d4c823a6eda9f3c5937fd0da2e7594ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "195ce8af639e1d68b45b257aeb18e7afa42c54e16e0cb7b8c602943c36fc0cb9"
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