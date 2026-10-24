class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.106.1.tgz"
  sha256 "f3d70542fb5b8af7abee8d4f1febed2849fd349b2c2f4d2a3d54bfed93d825fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e29d0eb3efb276331e0377b8fcf816284d9d5886afed1382695a78f48f211308"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e29d0eb3efb276331e0377b8fcf816284d9d5886afed1382695a78f48f211308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e29d0eb3efb276331e0377b8fcf816284d9d5886afed1382695a78f48f211308"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4801d9265257d34d78d7d4986d457302bab0a784c609a1bb924031a8b668ac67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b5127fcac7f823105dd7231de0291e051f129e694da4b2aea221e6ff32df5802"
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