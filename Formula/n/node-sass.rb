class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.67.0.tgz"
  sha256 "1a75c0d68121fa006b9c06f4675f8ab03fe46efb3bcef907a1910f38e16bc688"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "303d46fe0acc1f39b909e474aa9bc4350971457eacaa3bce867e92fb82b83128"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "303d46fe0acc1f39b909e474aa9bc4350971457eacaa3bce867e92fb82b83128"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "303d46fe0acc1f39b909e474aa9bc4350971457eacaa3bce867e92fb82b83128"
    sha256 cellar: :any_skip_relocation, ventura:        "303d46fe0acc1f39b909e474aa9bc4350971457eacaa3bce867e92fb82b83128"
    sha256 cellar: :any_skip_relocation, monterey:       "303d46fe0acc1f39b909e474aa9bc4350971457eacaa3bce867e92fb82b83128"
    sha256 cellar: :any_skip_relocation, big_sur:        "303d46fe0acc1f39b909e474aa9bc4350971457eacaa3bce867e92fb82b83128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcf603c1a6468b7ed4564d3b16e598b9aa12404ad1f10c3cdf9c9bd780da04c"
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