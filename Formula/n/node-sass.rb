class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.1.tgz"
  sha256 "3e5417ce23016c6e516c79b669dcd40e2454ef20f56c3703360618e236822a27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed8bd8057f9b8207368aea29edae95cc9d61e4e6a4d3a8ef7839554f57f3011f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed8bd8057f9b8207368aea29edae95cc9d61e4e6a4d3a8ef7839554f57f3011f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed8bd8057f9b8207368aea29edae95cc9d61e4e6a4d3a8ef7839554f57f3011f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed8bd8057f9b8207368aea29edae95cc9d61e4e6a4d3a8ef7839554f57f3011f"
    sha256 cellar: :any_skip_relocation, ventura:        "ed8bd8057f9b8207368aea29edae95cc9d61e4e6a4d3a8ef7839554f57f3011f"
    sha256 cellar: :any_skip_relocation, monterey:       "ed8bd8057f9b8207368aea29edae95cc9d61e4e6a4d3a8ef7839554f57f3011f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2f0a557a84d754079055f63cb1c3e8835dd9eb11211f52106f96add5c52baa"
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