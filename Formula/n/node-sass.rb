class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.65.1.tgz"
  sha256 "cf1b91ec37baadf161f6694759d43b3a641c3fe611fe48fd82bff6cf5b373654"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad2b658d41c010b796e3ac84b5b876539687b51c41eb3a54b4a5ef7872241cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2b658d41c010b796e3ac84b5b876539687b51c41eb3a54b4a5ef7872241cf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad2b658d41c010b796e3ac84b5b876539687b51c41eb3a54b4a5ef7872241cf1"
    sha256 cellar: :any_skip_relocation, ventura:        "ad2b658d41c010b796e3ac84b5b876539687b51c41eb3a54b4a5ef7872241cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "ad2b658d41c010b796e3ac84b5b876539687b51c41eb3a54b4a5ef7872241cf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad2b658d41c010b796e3ac84b5b876539687b51c41eb3a54b4a5ef7872241cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecacda4bd1dcc93634ce8bbb95f1ec60242e25a719372b5b7c638e7ec1f5c9ae"
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