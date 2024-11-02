class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.80.6.tgz"
  sha256 "e714ef3f595e3b1e1bcd81b5ae7b85e4d270b16ab8b485943942677b365fb931"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fadfc4b4332daa007b24acc7ddc8cc0b21847dd5a5fa810032ce9fc5c8354c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fadfc4b4332daa007b24acc7ddc8cc0b21847dd5a5fa810032ce9fc5c8354c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fadfc4b4332daa007b24acc7ddc8cc0b21847dd5a5fa810032ce9fc5c8354c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b28a760140153e0b57a222ad4b7a313bfb37afab9ebd6ea9abca41cb7e0da19"
    sha256 cellar: :any_skip_relocation, ventura:       "7b28a760140153e0b57a222ad4b7a313bfb37afab9ebd6ea9abca41cb7e0da19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a1f1ce67ee5f67dfe39a363ce73680bb165a094af0546d288879cff1a75d460"
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