class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.61.0.tgz"
  sha256 "f51b7d8e7a94a625e87e625a96117b2ca22ae41901d5ab8d9547d53f8dc3222c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da17007056a1f5329414f6be3de86e02eba4db2815bbf623c13dcf547e8f5d76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da17007056a1f5329414f6be3de86e02eba4db2815bbf623c13dcf547e8f5d76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da17007056a1f5329414f6be3de86e02eba4db2815bbf623c13dcf547e8f5d76"
    sha256 cellar: :any_skip_relocation, ventura:        "da17007056a1f5329414f6be3de86e02eba4db2815bbf623c13dcf547e8f5d76"
    sha256 cellar: :any_skip_relocation, monterey:       "da17007056a1f5329414f6be3de86e02eba4db2815bbf623c13dcf547e8f5d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "da17007056a1f5329414f6be3de86e02eba4db2815bbf623c13dcf547e8f5d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b512ad4905360e66500917448f50b9000685ed9cf9f0d8fb7fcc01138dc97a26"
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