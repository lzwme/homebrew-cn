class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.105.1.tgz"
  sha256 "f7fc3d2884afb479e48861eaf5c63cf9eb39a8796c902d9bb33eee18834cb2f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b62d09a14db168f3998f1d4ee70f7f646466deeaa0eb8e1d6c3710a9e74e6738"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b62d09a14db168f3998f1d4ee70f7f646466deeaa0eb8e1d6c3710a9e74e6738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b62d09a14db168f3998f1d4ee70f7f646466deeaa0eb8e1d6c3710a9e74e6738"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9832f2d6dbd0b616e5c8b64b6b3eec62cd9df7950bf2e1624e5a05df152764a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ce4bc8bebb558add1b689831f94c1de5ff6e48207806da331e24890f08617a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end