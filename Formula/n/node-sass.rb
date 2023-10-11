class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.2.tgz"
  sha256 "ad98bbba7a1310d8c3e2ccc3139833bbc69d42731911a18ec13963d800defd2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6493e881dd64ca10367cf2833acda66d0a3b1d32e4ed848e7da0028923f30b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6493e881dd64ca10367cf2833acda66d0a3b1d32e4ed848e7da0028923f30b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6493e881dd64ca10367cf2833acda66d0a3b1d32e4ed848e7da0028923f30b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6493e881dd64ca10367cf2833acda66d0a3b1d32e4ed848e7da0028923f30b9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6493e881dd64ca10367cf2833acda66d0a3b1d32e4ed848e7da0028923f30b9"
    sha256 cellar: :any_skip_relocation, monterey:       "a6493e881dd64ca10367cf2833acda66d0a3b1d32e4ed848e7da0028923f30b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6715009b56477bdb3ab0dbcc66bacd2d02e0fd4b34df5a6e272d19af0ba444a8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end