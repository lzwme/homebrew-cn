class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.80.7.tgz"
  sha256 "9cbbff85d175b3f57b2168a0ac88042d280123ebf899e1d20e134eedf1687f34"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "051750b69307b154e8effd99a2554a7edbabd487b4f9e3b7dc6f2f143c628c47"
    sha256                               arm64_sonoma:  "70c869d58403fabcf7d16d611b447ac7616f0537df911e94dd05b19725a66559"
    sha256                               arm64_ventura: "f3fb691ca9f7b5a1d5f2d991b6e89d84b5fbbca36d2d7b07697d65d3d6050b85"
    sha256                               sonoma:        "f6f9ef82ebf16c4ed29fd98a693b39abf0cd6b1be6eeba9196d9b5a8f5d8c9c7"
    sha256                               ventura:       "607d9ba35709b45f950f9fa795e310e247789a10e603f1c4fa9362f575687893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89bb530dceccd5e48957fbbcfb1cb2a6c44003bf2ef231cdad2f887e03edb191"
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