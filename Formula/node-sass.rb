class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.5.tgz"
  sha256 "1e8cd2bc717f9b8f2ed6d98952423fdad532170733c9056488232c0f735efc5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49a2b2a8ab209a7674b1a58ffae13c8744f0f5684425a65e6f5c53efc126f276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49a2b2a8ab209a7674b1a58ffae13c8744f0f5684425a65e6f5c53efc126f276"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49a2b2a8ab209a7674b1a58ffae13c8744f0f5684425a65e6f5c53efc126f276"
    sha256 cellar: :any_skip_relocation, ventura:        "49a2b2a8ab209a7674b1a58ffae13c8744f0f5684425a65e6f5c53efc126f276"
    sha256 cellar: :any_skip_relocation, monterey:       "49a2b2a8ab209a7674b1a58ffae13c8744f0f5684425a65e6f5c53efc126f276"
    sha256 cellar: :any_skip_relocation, big_sur:        "49a2b2a8ab209a7674b1a58ffae13c8744f0f5684425a65e6f5c53efc126f276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64dc867c7effc1c2bde7c7250323c4590a480b8e5f380391e088908a200f94f"
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