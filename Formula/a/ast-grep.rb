class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.27.0.tar.gz"
  sha256 "e20dd7d287ee796868f1a8f944533e84630fcf1cf9dac82c89f810bd45f6a056"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d175dc9c8e09d9c265bd61b0668d0aa1cea441e9cfa24793745c0ccd0d57f84b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "018f42b0a8f9fbe17c64313973ae131a395666a294b617c9208bc9855b683886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a935490963b8629c98a1aed88c2ccf5a8c246803303fcea0b5d376126985396"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d091dc043459b2ce03373e43e336178f5149a03f39724969b4e5820672b11fc"
    sha256 cellar: :any_skip_relocation, ventura:        "82c73567db0a39fb62b215934f6f8f24050d50b48ff75b415686c0d3d9958d93"
    sha256 cellar: :any_skip_relocation, monterey:       "ddd2a22fbcb03ba5ec4d123f80ae2ec683da93dc82ee5c3e7812fa6665f607c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "544552e1c9d517e693148a62db6e813d3ec208833cc4df0dfa8a546d48abf078"
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