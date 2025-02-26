class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.85.1.tgz"
  sha256 "eb394e752785037e89de63762c00a4b4616108cd061d70a817b59e003954fabb"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ba00587c565eb8ea21a6393ea3638fb1b86e0632aaaf7bf9527b557201f11050"
    sha256                               arm64_sonoma:  "6d803855bc38f2d3348da2458f2321f6a9a0e8b212b8c3dd64da25ba0a9d2e6b"
    sha256                               arm64_ventura: "d9b8844c35e0eea8a113fc733301407e1284116443ebd3b0bda35ec255861c62"
    sha256                               sonoma:        "bab21fdaca48601d6b1786a56be2592d31bd76fe8d282f51862a320ce9aa2bbf"
    sha256                               ventura:       "49ce802d7cbd2c6d9b35ecbd46588a1b32f96298e3bbbe864f3a5394ee6f5b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddfcf4a97ddfeb45060e8051921a4e74a14a1340659340ca47cc0b36f28c9b7e"
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