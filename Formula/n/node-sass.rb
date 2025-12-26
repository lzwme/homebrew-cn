class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.97.1.tgz"
  sha256 "9924efab78e05ad1d41367d5390db3bea84d0bfe42d63090c7f059cdfd778b87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a583de0c9dea4dbe0e2b07696d103b122f37a3d405d6de4f0b1d06acc98e993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a583de0c9dea4dbe0e2b07696d103b122f37a3d405d6de4f0b1d06acc98e993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a583de0c9dea4dbe0e2b07696d103b122f37a3d405d6de4f0b1d06acc98e993"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4adea9f4586fda5585167c92052e0324da60d5b7ff69d9ba2f1d6b9edcf2af0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c26e7380edd2889b861dff7000c88156c58b269d6dcdb9d557fedaf67db2e133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a8966234face4d43ec7993a4016ea38c9d3fd6739dc5f479af2aa896213097"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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