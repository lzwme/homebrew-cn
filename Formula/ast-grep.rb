class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.9.2.tar.gz"
  sha256 "b02ea7667fc5fb1779afb805731ba005cb04a2590c37c1ac140d5912a3c651d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e03a14929fd77a55b7c4211ef0f084de642878fe857133f250fa5d1c46523a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "558fac74899463e43041f62116a6026b0f2eee767dc288c393727de36da90ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "504a32e6956d0223e8736614932c40e3c64e48d85b52c927bd869cd92d139a58"
    sha256 cellar: :any_skip_relocation, ventura:        "ee8e01f556a7fc85c0729cd97a16e59641b7dcc028a0c247019aaecaef2c9889"
    sha256 cellar: :any_skip_relocation, monterey:       "22428a47cd6c77ae6a8c3b938a195adf8cab552dafafadf84f1885e3ab327b75"
    sha256 cellar: :any_skip_relocation, big_sur:        "cab6dedb72e47d5d7d48c7957b74e501fbd7ab5f750dc204b607110334c8195d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1daad3c1523205f2bab2e912df7ca32a28ff925e3a0f855bee7476103735717f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end