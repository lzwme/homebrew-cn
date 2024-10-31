class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.29.0.tar.gz"
  sha256 "6009c6dd7434ed9ec4661c90f7d8f4102b390d1b804c24acdfd6e86134b0f274"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1306c620ef8da968551ea8130e83c65529cbf19bef02acfbf44ea4a17066b07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d263a3f933fa0674a83008d2100e065c4414db6fccda6937e1c26324c8a7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6672bf75ae0f1866f23ee1ba8456ca78794db6d1a93f00d3681106f920666df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f1889bbc4b813c5780cd7d9f66f5839ab6535563c165ac618b706f1055f7bd"
    sha256 cellar: :any_skip_relocation, ventura:       "ed40d82a90cf0ea9ff883bce113a16f937c858488ac177bd538ea61fe6083e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ce4987b67b39c512effb1eb3d1aadbe4c3a1c264d7f154536fabd1169542fb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions", base_name: "sg")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end