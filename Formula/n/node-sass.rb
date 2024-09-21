class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.79.3.tgz"
  sha256 "9a644c45bf2795edb4dd88d740c82dc771196b06578c04fa8d66a048787471e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26b498f3b9dc2c1a8498d3a550a46444af7f164c4ce9d44a6f12caeb7dae051a"
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