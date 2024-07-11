class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.7.tgz"
  sha256 "a81d41945c54fe3bb076710a2b595791af10f968e47e76f06d4b5d95e86522f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9007b19ab49261f654d2679c0337753b7f9b9651aa6037b7914488967f5976a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9007b19ab49261f654d2679c0337753b7f9b9651aa6037b7914488967f5976a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9007b19ab49261f654d2679c0337753b7f9b9651aa6037b7914488967f5976a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9007b19ab49261f654d2679c0337753b7f9b9651aa6037b7914488967f5976a9"
    sha256 cellar: :any_skip_relocation, ventura:        "9007b19ab49261f654d2679c0337753b7f9b9651aa6037b7914488967f5976a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9007b19ab49261f654d2679c0337753b7f9b9651aa6037b7914488967f5976a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e9b5655c9d8ed560a1b6bd1c0ec3b35b352fbbefd89bcab57f65e80e1db067"
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