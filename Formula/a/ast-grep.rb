class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.22.3.tar.gz"
  sha256 "26bff44cb477e77c55ec4dd75b9c7d00b3db0e9d28cfce1bc42e6518194717ec"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04d2b6d1b106e2ba7227623abf39863f7fd9eb5dbf67fdec77c3998446ef4d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "284abb40f94a14b5df4645896d61ed3afa0c857a7f9fc28a5d251fef5ff6fc32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64acb1a57e198a6dc27c294762434d421c364e16a80300380d4e56a683bba433"
    sha256 cellar: :any_skip_relocation, sonoma:         "b54a880e5c0ca037c1769e8d780fa89cb4290753c115e6e9f8a70528a18862a2"
    sha256 cellar: :any_skip_relocation, ventura:        "c09b56d4e8191b8d9e011cbca312cc9766daa1850ccb721a5b424b52a813b6fd"
    sha256 cellar: :any_skip_relocation, monterey:       "37b0d4cc72b82355d26f1faf405d731398b033365a5eb25dbf9cde4f05641c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8daeb25ff6634667ac23f7d8405f76fdd24f7615f24e7c0efb5d7a6808b08dd"
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