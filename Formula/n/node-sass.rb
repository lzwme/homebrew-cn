class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.95.1.tgz"
  sha256 "a9365f60df8b4e5d92952b097cf9011ca63ad0c5cdd7e99686e76f2620e04664"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be6a1475648bc348afc5a80b3181c185a34973da07661af4da4d2919fd0df666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6a1475648bc348afc5a80b3181c185a34973da07661af4da4d2919fd0df666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6a1475648bc348afc5a80b3181c185a34973da07661af4da4d2919fd0df666"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b1b78bb7fa0654c2cf1da2e71e0f75dae797882ba8c31d73afe772ae67be09d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de471f38cca26b297e56f9b00ffeac1c056814c641926f56c490d76015aa267e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f3efb0d5658dba9b5cc87b95dc03f39daecade711b52db84a184b72b894971"
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