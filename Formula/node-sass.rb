class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.64.1.tgz"
  sha256 "a4fac9b8a33f1d71229eca4256032815eb543fe74ed9b1759ff4f57b6d3064dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "266072fd5e8ed33e795f018be27520e28407a1e8576fc7ce635cec3e8fbccf50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "266072fd5e8ed33e795f018be27520e28407a1e8576fc7ce635cec3e8fbccf50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "266072fd5e8ed33e795f018be27520e28407a1e8576fc7ce635cec3e8fbccf50"
    sha256 cellar: :any_skip_relocation, ventura:        "266072fd5e8ed33e795f018be27520e28407a1e8576fc7ce635cec3e8fbccf50"
    sha256 cellar: :any_skip_relocation, monterey:       "266072fd5e8ed33e795f018be27520e28407a1e8576fc7ce635cec3e8fbccf50"
    sha256 cellar: :any_skip_relocation, big_sur:        "266072fd5e8ed33e795f018be27520e28407a1e8576fc7ce635cec3e8fbccf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92e5a422476787da4b1fd0ccc84c5809278f63357956dd00f46c5c3192c5d3b"
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