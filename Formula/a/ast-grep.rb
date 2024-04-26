class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.21.1.tar.gz"
  sha256 "55a12f59232c03b0517abf42237533b915ad14c364ea1a2ed38757cd01aeef9a"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c56baba2ebcb81135ae22f3930dd3dd9b20ba86f48e71f1f0dca1cd86df342fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb8a2095716c3d5f6911ed270248ee9b41ca70c62aa658c0ef4a65ba37399c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c7137d37c3570bc1a6b21895380de2043bb04c7c74d5e0b06f28400a622c3d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f0b254c0aa3d1e489482e46b14badedb7e0e275f6d304d34a7451d65657286"
    sha256 cellar: :any_skip_relocation, ventura:        "707fb5961f06d0060cc52537d9896b08bb65999e586940e690ad8859289a697e"
    sha256 cellar: :any_skip_relocation, monterey:       "f32d949d84918889cac135d4ead83348df5b465d388fa831391053aa941d5783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a17ef3f9b99ce21b5579aee8e7a82d683c28a178e952c23cb371508289c103"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end