class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.26.0.tar.gz"
  sha256 "19bcfa9e0c94ce2c343cdaa4592e42df3b5e794bd5fde580a9a73f7b4ab7b142"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48f7cb271a7231dd6b1242c7a06353be70c401b77ae1cdc3a778f6e8c948aaac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b6dcd463d61484b5c891fc16bf1429d0077a2d3b562c198699081ee7e077f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0937d013f3c41acbd05dc114a989e2f68f49f5910d70aea3e5cf0afe49ddb99a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ab0cc9ad879d6c5e7a5036b330a8780d5ccee044b9c4ff9f7fb84fd6d8ad55c"
    sha256 cellar: :any_skip_relocation, ventura:        "77cb9147133e32b15ffc212e780d58a39bc0c8ec47299f8b3a8a95346cd6ca05"
    sha256 cellar: :any_skip_relocation, monterey:       "03c60f374a6fd50fe571bf20555c14ec4035d7a2d3fa9d50cf673e66a1dd553d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f81cf503f6058bebf640f2d3bce614df4f7373f5ffa8f44a84734890fb379d60"
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