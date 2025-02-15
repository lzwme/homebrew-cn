class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.85.0.tgz"
  sha256 "13885588dade863272408770e665534d67966c31a318664ff5babc56888a8d8a"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "5349a83f4a6db9ddadd8357effa594a5aefa94c2b868dd19c391bbcdb8e1aeea"
    sha256                               arm64_sonoma:  "8d65334c0c4208851ff952c3d8288b3872e1b9890fc38b0b8d0126d2082eb9eb"
    sha256                               arm64_ventura: "0b78bc6395a99f3d5e3a493b9056e5e5ac829548760f952515e2a28efe39c0d2"
    sha256                               sonoma:        "0875d06a66c67f5e8ac11b5c29a0f92aac5211e9d10f3d50c0bae492a30d3fe3"
    sha256                               ventura:       "03ccaaabe3999dc7d3a9b7e1639a0d6e8b0d85e89876ce99d31aa7d16a007288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc4a97e40a17f4bae2003e4a0949b04a2a5c0471936503ab2fdbd2db73021ac"
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