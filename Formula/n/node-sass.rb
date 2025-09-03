class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.92.0.tgz"
  sha256 "6fd24fc348e7df9b3a039392a26ec0efb1b9ef69d5461d79a4c68fc5f493ac44"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "7721a5bdff49d15fdec4168184262ba2efcc6ee670e2bf973d4976dfacfe2fbf"
    sha256                               arm64_sonoma:  "006a33837a070bba156a09f31a7a38893e8b63e0e3f0e52563de5bfbdfe2328f"
    sha256                               arm64_ventura: "c206d02cf221284f6e41e4191d31449c8e9b757fd99cc341642dafcd5d8a032f"
    sha256                               sonoma:        "0879a71c3c6f7729a867d95708faeda1343d0383b1b68962f8a0c1f6891e6e23"
    sha256                               ventura:       "296252cca02b98f180967fa14f11a8bfbd65e40e318bbcef351710d29d4baafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51bfb7ef03d8ff2f25af444b6290681b0f20b7ff12790eb69c01bef149a7745d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24658231aa8062b78f58091ae8474caf2fc355caa4cbe483b1b6f2d482c1175"
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