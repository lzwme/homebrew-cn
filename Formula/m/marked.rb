require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.0.1.tgz"
  sha256 "975df3858273aae162dbc31c24e26d3dac58922a5a95b441dc3fbc4ce3cb5991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef9904346dcbf87628fa6d1fa216a23f06aa5f2ec7aca53e88c9a368c75d34c7"
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