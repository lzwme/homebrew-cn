class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-14.1.0.tgz"
  sha256 "7bc39271379559340afcc5a0c7b9dad397db61ee53c28b451837183b7ea95470"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9dbc39da60f4574d4a30b69f4ae594377b0c683c915e9a4dcd3d602fbad67287"
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