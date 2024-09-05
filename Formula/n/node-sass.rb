class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.78.0.tgz"
  sha256 "1bc781700982dda0b922818dfaa802b9f2f343bd1fda8bd760edc65bb9e86b42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "842c73b1f6a1f35613dc5242b476e3076daf5ea36d6c248b412c8989c78c148e"
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