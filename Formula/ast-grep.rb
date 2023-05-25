class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.5.6.tar.gz"
  sha256 "3de31fb334c151557a2795f7273488c2ff3a049487783a8267e477702d6a9240"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05f23a9eb84dd99d4bbc8baaac05a96294a15ecf9ce0b95605c386a09fb101bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "939345df180b5096f3012e96719a8d133c5e821c1139a29eff9085d39e91377c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca948f775835663790a6e4eba2dcfd25a0bc15719357dee8703ccc4c412205c2"
    sha256 cellar: :any_skip_relocation, ventura:        "c54d5d080264d44994c11b7c76edef0c01863fa24e78f721ceb008cd30dd4eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "ca36f0014fead55e52ec29a5f49a67cfd2314c0e78e8069192bcf59ca8906ee1"
    sha256 cellar: :any_skip_relocation, big_sur:        "59e7c7b46225334d8a5e46bf1c8bce55f35015f1c157f889163efd434cfcde27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6ea6a5390f9e0dff5fd2fd94300e5d1138ee4e25cdffe7d9cc7420a21fb3f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end