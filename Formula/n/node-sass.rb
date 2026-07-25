class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.101.7.tgz"
  sha256 "1f1a881eb9b9e2be1eee501d08d500e4b0fbda071b52f4d21e8c4758d1f8bb9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2db356aa0e177010a4b6907308f529458adcf7a7fd9d6d49c1414af511c1179c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2db356aa0e177010a4b6907308f529458adcf7a7fd9d6d49c1414af511c1179c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2db356aa0e177010a4b6907308f529458adcf7a7fd9d6d49c1414af511c1179c"
    sha256 cellar: :any_skip_relocation, sonoma:        "015283836271579becc75fb2c9292275c46b211afa0dd08cfd7fbc62c125aff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0319beef26936187f4041710a825ad046d40228a29df04dcecd27fd024712e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a8f6a88a3c323587e4335b9692c7d01ee01b15e23789aed0597f99d41789a7"
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