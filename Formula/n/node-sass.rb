class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.93.3.tgz"
  sha256 "a6b29b6184c82f3a546b38b54aed0bac5e4f2c8597bfc780a3e2d6a7bc603b1a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a9ce7d832ec585d2d83453e090ba6f6267d898a467a8e25aab9586acc8f09a67"
    sha256                               arm64_sequoia: "ce84a55167655ef91c7f8af484c9830311d945664257ee276653b42367e5d0e2"
    sha256                               arm64_sonoma:  "432b932a2d3c40936c644994ec564ab7d4f1dc631df4d477ab539f954a3b2aac"
    sha256                               sonoma:        "fee63a89095e62ecd849722784784cb80c3ef031f0dfb1c39c938037e55cfadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd06c922a30026b5275f8bd56db7e3d24de0b3c990ba87eef58f7ebd8c77cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cdfb391d136ac0bc153c01a22f05ac47c05898c552a26b7fc3231d014cf6e93"
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