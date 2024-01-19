class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.70.0.tgz"
  sha256 "4def4fbf34429d597b80b15178e27510d31017d8b2cdac1dc82f5aaf177967ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61f9281e769184472a2b37bbb7f270bad90644b95676db833ba4ad98315b0779"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61f9281e769184472a2b37bbb7f270bad90644b95676db833ba4ad98315b0779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61f9281e769184472a2b37bbb7f270bad90644b95676db833ba4ad98315b0779"
    sha256 cellar: :any_skip_relocation, sonoma:         "61f9281e769184472a2b37bbb7f270bad90644b95676db833ba4ad98315b0779"
    sha256 cellar: :any_skip_relocation, ventura:        "61f9281e769184472a2b37bbb7f270bad90644b95676db833ba4ad98315b0779"
    sha256 cellar: :any_skip_relocation, monterey:       "61f9281e769184472a2b37bbb7f270bad90644b95676db833ba4ad98315b0779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af287ff55a5dc8d20add987849b319a18e12a578c0a293482de77b65d3daaefa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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