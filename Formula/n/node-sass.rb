class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.106.0.tgz"
  sha256 "64f37f535e43236c3204a9e3aa34f823a0cea3a31dc5a8209b1dd95416f3963a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26d04b1217e58863f8b51837b130dc0c2d72a6fe8929c794c6d88764e3119532"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26d04b1217e58863f8b51837b130dc0c2d72a6fe8929c794c6d88764e3119532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26d04b1217e58863f8b51837b130dc0c2d72a6fe8929c794c6d88764e3119532"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "607fea87bc2ef4f51c0ce073943aec10eec8263bb1f281354fd4f99360008b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c01d097b2ab54db49eb09113ded3401df38ab2dc94a1c725cd838b8de22e3695"
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