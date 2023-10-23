class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.4.tgz"
  sha256 "ce91baadd5f9b0dda64ab97f76d34755ef20d37fbf5567ba0996b63bc4851579"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a2399a1e01ec77fa937c782e3551c92db2fd3b2dff5698d3b915162af243ede"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a2399a1e01ec77fa937c782e3551c92db2fd3b2dff5698d3b915162af243ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a2399a1e01ec77fa937c782e3551c92db2fd3b2dff5698d3b915162af243ede"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a2399a1e01ec77fa937c782e3551c92db2fd3b2dff5698d3b915162af243ede"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2399a1e01ec77fa937c782e3551c92db2fd3b2dff5698d3b915162af243ede"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2399a1e01ec77fa937c782e3551c92db2fd3b2dff5698d3b915162af243ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1756c911227e6263e6e593fa25f63117d0181f4e40c147e236a5e32d519294ac"
  end

  depends_on "node@20"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

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