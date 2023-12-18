class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.15.0.tar.gz"
  sha256 "5820c9d2cf9f4370701947297957c1ebacd4c27a04fa4c5a7da63e3e183ea56b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f98033de53f1096eee3bfe81cf0fa32b81bff29246c1883f411f8c16253fee43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8bc34c0080a00416764ebcd262e306c8036d1339d4f86dd8c3eed28031006a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cbb853e33b8da09e47884a967670b8b00b43ae32e952c0c4e78c2bc7078175e"
    sha256 cellar: :any_skip_relocation, sonoma:         "53f4505a4810e8ac469e57e13ff98234df4d4fd052def3208c339147ba5cb245"
    sha256 cellar: :any_skip_relocation, ventura:        "9b008d1142a3601db132976d8c6d4e0a993711c22d32ce21cad9e6ae3b971f72"
    sha256 cellar: :any_skip_relocation, monterey:       "8408b1f0779c02c3531872821b9e5667e3b6a2117ced5cc29c631c59ae32696e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e22cbfe3ed58472bb574231f0b09c76f556be2d57c1f4e35877c7bbccfba0c9b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system "#{bin}sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")
  end
end