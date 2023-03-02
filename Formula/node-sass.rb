class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.58.3.tgz"
  sha256 "25a561e2edd814c3e0ba11a0c7123f7e3735e6bd171118a94e09e1034e05fe0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af19ccb3fcb899c368c8cf14595008fa7de635d8020f4caf8c2ffc0e298b76b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af19ccb3fcb899c368c8cf14595008fa7de635d8020f4caf8c2ffc0e298b76b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4af19ccb3fcb899c368c8cf14595008fa7de635d8020f4caf8c2ffc0e298b76b"
    sha256 cellar: :any_skip_relocation, ventura:        "4af19ccb3fcb899c368c8cf14595008fa7de635d8020f4caf8c2ffc0e298b76b"
    sha256 cellar: :any_skip_relocation, monterey:       "4af19ccb3fcb899c368c8cf14595008fa7de635d8020f4caf8c2ffc0e298b76b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4af19ccb3fcb899c368c8cf14595008fa7de635d8020f4caf8c2ffc0e298b76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b625c183bcf424b9f58b68b276417eaabf34251a5a9025423a14a9255a1913a"
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