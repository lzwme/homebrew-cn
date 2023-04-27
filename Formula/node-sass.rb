class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.62.1.tgz"
  sha256 "dbee140ec1169f99a8b4fc23eaa1c34b7a038f03e3bcd7e1f450b5307d47961c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63bee06735948ae0c4a178877372233bc88e0b7b069a75dca764835d0b7e79f"
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