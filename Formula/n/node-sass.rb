class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.81.0.tgz"
  sha256 "0b5d0f6ff1e3ff08fda94b4417d312114ca8b3aaf26b9af3cd0affefd5be2158"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "7e8631d13ca567028c115e2ee3aecc62a1a7ab6146b61e76a4889c1e25937a19"
    sha256                               arm64_sonoma:  "9d01ecc3353732b5e31d496c4a5ebd069cfbb41a4fb3f8fa48b9356cfcd58a1d"
    sha256                               arm64_ventura: "1faaf794bf4d3daa4f68de7151224b68480440f048691c31782f94b8fefd80f7"
    sha256                               sonoma:        "76204b4eaf001af0f73a113f661e50351ce55507e84aa9b9cce7f5576146b123"
    sha256                               ventura:       "2cb82a907fe4db2a7593824ed90ca00b779d0b3b39284fa829431631ea475e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888c2bb73f87512b289a3af0de0a5afdec599400f6c888a15adbc42bc6a4684e"
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