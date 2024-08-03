class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.5.tar.gz"
  sha256 "4a12ca4c00c6743d5e6429cc203ce241c5f68c5c329d0e4c52c012fdc255527e"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3300a8f0580a4fe4fdbac755026bb024cd9f7a1eeed280bd49b99a11477c2f55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8057405be71135779f3608c949635afe3fb11d9bc0b0e80cff2c095ba68e8c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ee399e7adf0f2f048ef9da968b7c20446e7b364c70e79b77e64fada059f426"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a6e9e5d13b654a8f73079cac7a81dc7983211cfb036fcdb05e583456cbc14d7"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf0a4b874bb86b038842452ff16e3ed4f47f0cfd5b05a677e1123f53096f1da"
    sha256 cellar: :any_skip_relocation, monterey:       "c003483e6552a9c6ebad7463d791cf6182533c96e30986b8128dfaa98fb2a39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07f2bfff7411f8e94d2851113c6fb2cd2160f00289b65bedc379c97b3813f15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end