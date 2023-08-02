require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-6.0.0.tgz"
  sha256 "ffd373e71a447ec35a3030f73c42f7af59b6b102f6a4a59f4bc3ecbe64c34dab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55da1179378a493b7cc1b5c6fb2cfd8434a0be74404a60650d57cb541e4c887b"
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