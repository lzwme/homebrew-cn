class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.83.0.tgz"
  sha256 "77fdc3eda7d5a8330b3c20e8c05142b171768b6bbe2cb3017a01ce6812540cab"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "4debefd83cabcc6b2fc5e9d1f6beb368cdd368ead2fbe3ef235bc9a862fc2f86"
    sha256                               arm64_sonoma:  "2d9461e8c37e96d3105d9b6b783b27304cbf299e33903c600266ad111eef8d91"
    sha256                               arm64_ventura: "02cd356892952d7b5640272ca8943e286c1b4409101e4520257b1be07f2fcb97"
    sha256                               sonoma:        "bc3b689d24fb0142ad45c5287dda381de1942311151cbb86826cfcbbd98c1c59"
    sha256                               ventura:       "c9051e042f42248184d2fd2115d9463dd1f156bc4bbf2498f3a89197d8c3c681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc76ca9a64b1e9b07300b58e327ceeb8964dfaacbb7bae9a585c6dcbb726d1b5"
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