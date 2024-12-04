class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.82.0.tgz"
  sha256 "099d93722f6cc749f7e88cdfc39293963ed7460eea498d9084dc57fd63d30b66"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "9ffef86ee94bb0733cbe30978e6f2b4026db2583418806876166457238235d90"
    sha256                               arm64_sonoma:  "4875d4475a9d4cb5e63f687de078cfe3cbc1cb8e8292ecbc0459ce317c7e1da4"
    sha256                               arm64_ventura: "e60b73f0436ba7ab2d01230a7b904fa731c829d327f166c94fcbfd916f5ad9b8"
    sha256                               sonoma:        "c9824aa7ef7f8d2a9d2ab0a50ee3db36459708ed4a890176844c9d37381961bb"
    sha256                               ventura:       "fd6b212a2c7d09c2e99e2adc95bad9d85f34531fe8ecada07a36cd121736c706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5da0ab3a7662cac59710636cd09e8bc6d769b60be0eba6837d7b58ebce4aef3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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