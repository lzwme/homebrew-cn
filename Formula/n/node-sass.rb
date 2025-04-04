class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.86.2.tgz"
  sha256 "c0e363b772f8b91addd856147efa661b8e8e362a5531807db471c0364bb496dc"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "210f8ef6c9eeb2867da09de69ca2d4a80c78f0ba2c2b9e6fa9fc74056bd1e4a6"
    sha256                               arm64_sonoma:  "ee21f11634f188d87b9d493abc838539c01fffb74e09f498bbbd0875a96c572a"
    sha256                               arm64_ventura: "89a69554964f78c1865fa39cdece650deea1593f144a894c29686147c6305bc9"
    sha256                               sonoma:        "6833c16d6e65df0995a90a1cf7ad148a5a3c9d17155b891101b5656fcee45d08"
    sha256                               ventura:       "80fd8860c4363d26c13534d7ac9a036437f86e22d53f3e39d7370066c55dbb18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe940d7cbb9e94fbb2736ce67ef186f1bddb60892158319ac4d6b1da2ca6e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540c79e0e275a2d4619fe263f0d9d107a1f667d0e143202de34fbcb373a2f6e2"
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