require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.1.2.tgz"
  sha256 "3f0d89700e0a1815dae5856f398a59ddd87898f759e7f5232f8937c5d1f6a69e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beba770c308f51f3a5422bdde55eb67f73a880e73563af01f2a8eb0dbfbc25e7"
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