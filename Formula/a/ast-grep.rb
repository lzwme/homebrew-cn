class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.18.0.tar.gz"
  sha256 "a1021a96fe778fcce7e600727e862b1b37f51031bad9f85d5d99c7f1aef2ffda"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be2d95eda69dfc4a64b02a3512d14d43b516cee193159a9e9b1478a36f1796c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "525e325dfd821457c6b2a6111718e6bccfeada9e8852b7f81606c466d5cb8a66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a0176b316525b6e235abf567146ff6088fff9060d3f4d8c926b997be4da6fbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f47543aa98d3867b9f5c69b620232edd5134ac4a49469e3c679df83e2bf93f23"
    sha256 cellar: :any_skip_relocation, ventura:        "466b9a12ed605796d5e51c2d07547aa596f3c4e40fdac03ae67b684518b79436"
    sha256 cellar: :any_skip_relocation, monterey:       "68e41e53e2da58d387063406f591a4846c0e870640bee7fe8d34965699e72c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8bc3a4eff9063f335ee3080cecef77b0c51db508bb8c7b56517f3e64d74f63c"
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