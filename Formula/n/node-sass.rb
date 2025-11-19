class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.94.1.tgz"
  sha256 "7b03b63dc029960fff92cd5e45ff2950dca9809e76e0184609f6be2b87eee521"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0869f61ded4d6aae701a9ecf49d97675fcc2cdc092fdecfc2c4fe13a6f65adee"
    sha256                               arm64_sequoia: "6f2aec9f33c6d6b50d64e4aa39f614c873d42c67f8059347f7e7d34299cd92fb"
    sha256                               arm64_sonoma:  "ad12d265187b30ab028f737102151602fe3a411bb9c4d9dcdc45ba5b58efc1a6"
    sha256                               sonoma:        "0e079f482705820f2c6eb360ea636ca284c57395ee993620eabd1ebf7d9d8f4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d7a30f7fd3e55ef4da8f0bae0390e038ff4ebe0e6f2b57a543b930c204ede2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7dc0cfde48c5fabb4f6cd9434af01572e3c7bc5c6d29b708bbd6efda0b7e141"
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