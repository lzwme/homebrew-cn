require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-10.0.0.tgz"
  sha256 "7a59fa1e236734cae675636fe2e9f99dc826db0b020145618d1f312af919e2a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "394e9b24557f7ed74aeded8b896a8cac4629b9fdce210ec1efdc140d4fd859e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end