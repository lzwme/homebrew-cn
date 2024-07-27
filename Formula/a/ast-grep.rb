class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.4.tar.gz"
  sha256 "66253cd897fb6426121db7bfbf20b749dd25b8f88493d7481c1a6d85df8ab928"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "568b84a13f8a23f8095680c1795f9894d665628ef466e6b1a880be365194b436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02aca56aaf081671f6823de633a49b54f17bbef7bd5f60d6ef20f46f02252c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaef39f423370dec92fc3bef040b0dd716a4c971e37ec111f8a1fea97bdcf8f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7f1c3366d28f1fcf3cbb30f3ed0ee3b8269b82b517e7347e7dfb631fe6650e7"
    sha256 cellar: :any_skip_relocation, ventura:        "199798bf860f52b274acfef4884a4192874f71bf286741707e8c1195ca76eb14"
    sha256 cellar: :any_skip_relocation, monterey:       "ad27414ab33b94033d897152ec6ba445fac8df4e898cd539c4220550ce5652dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8536f0c87abf9ae1de5fc4b9787d4a056da59abff44622818b8762f1cf6b69"
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