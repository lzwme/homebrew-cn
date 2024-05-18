class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.2.tgz"
  sha256 "e2e012492faf4dd895cb6c13133e81c4d42987fe06965c5850acb962099046b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e7496871a81cdc63be60ea0b2b3b8a3ac228adba07efc315eb480e58dcd8b25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba962f361a81ca7e0becd63df1b958d4ad749833a91c010a8f75d78495da1027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2d94c1af886ea73956dbe628d1801ec25766b444980abca980b2bcfcb12e38"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a548f7444d726fdabc14bcdfb7fe83d5273460a00857019a88a0112a3a30c48"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b9dac53a58d8734d305073799bef59dbb766e86e64adec3611a15305ca729a"
    sha256 cellar: :any_skip_relocation, monterey:       "6bd3a3035a4e4ddd6cf09c287f66fa1cd7241049a9098685e30ac7c458b04b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42a84409b738f3c109795b9a01801e599e327b1825277dd27cd172b4a54a78d"
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