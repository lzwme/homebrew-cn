class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.3.tgz"
  sha256 "ba89a369c01e739a84bb38f46566282055562a5448856eb3559d36124a085911"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d58b74de43948102f50df8835c5b36d640a1caae9bb7e4a47fd88933a37b5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d58b74de43948102f50df8835c5b36d640a1caae9bb7e4a47fd88933a37b5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0d58b74de43948102f50df8835c5b36d640a1caae9bb7e4a47fd88933a37b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d58b74de43948102f50df8835c5b36d640a1caae9bb7e4a47fd88933a37b5b"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d58b74de43948102f50df8835c5b36d640a1caae9bb7e4a47fd88933a37b5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d58b74de43948102f50df8835c5b36d640a1caae9bb7e4a47fd88933a37b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672ae564e51ef026f6c92bd7e8adf3a7cd0292de2a16952a5a84115184b81567"
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