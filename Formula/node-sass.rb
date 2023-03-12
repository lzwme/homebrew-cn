class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.59.2.tgz"
  sha256 "e905f4af08bcc18ac9e28592591db4f9c696d98a0a85826a72bc6c3d62ddd53a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ef9baacfe259d1ae6373c242b2705bcc3f51d4d41c193ae5622c47ce7162fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22ef9baacfe259d1ae6373c242b2705bcc3f51d4d41c193ae5622c47ce7162fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22ef9baacfe259d1ae6373c242b2705bcc3f51d4d41c193ae5622c47ce7162fa"
    sha256 cellar: :any_skip_relocation, ventura:        "22ef9baacfe259d1ae6373c242b2705bcc3f51d4d41c193ae5622c47ce7162fa"
    sha256 cellar: :any_skip_relocation, monterey:       "22ef9baacfe259d1ae6373c242b2705bcc3f51d4d41c193ae5622c47ce7162fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "22ef9baacfe259d1ae6373c242b2705bcc3f51d4d41c193ae5622c47ce7162fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5da30cc64ba2c8fcf312cafbd9d9a758951880ebaa3584b2ffc1d97201856824"
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