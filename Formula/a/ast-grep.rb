class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.50.0.tar.gz"
  sha256 "530ecaf2d9d048bd6aa07645d1c273ea2eded0a0707c7a807240063fc7bcf88f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7f1f9f4b996b336f19bc727515923d7f0e82119f235b680fd266564d22b6f7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "117c53c9af2cec4de8776825343529418bf9bab8e5547b50316a6e0584826233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d18830eb9f88a927592a34451d75e396b70aa91c6c9a1aeabc70260280bcdb9f"
    sha256 cellar: :any,                 arm64_linux:       "15d3100982932163ca5bb217e491813728c64746d65c7076bad886541d21ebe0"
    sha256 cellar: :any,                 x86_64_linux:      "691fdccda88197c684ddffe9d9cc3e4ec60f219880e919e60be8c8c80cf86c34"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end