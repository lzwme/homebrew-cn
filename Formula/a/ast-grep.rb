class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.31.1.tar.gz"
  sha256 "909ed53e37a9060a081cf0f92288aee882ae6320f0d894118f9c5c63123e099d"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6766a5d9d1892e540c3e4beb9288032408d84be68239217858445680c541b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea1f6fd81f19e3a7c38235a632d272e4c7b29f1ae99af34e216b17f09677e076"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55a5bdfdbe717f25f89edd0065a3e769fc2c9cfb0cb8a48608e89ed6d9ebcab9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c6dbdd4c6bdd16cb9450411fc56fa7679c178d191690e9d18e3f5a687d342a"
    sha256 cellar: :any_skip_relocation, ventura:       "82de042db9a0f748ed930ec0fff6ae5cf7449c877b02f06e4180f03ad1e48766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a785e20534ee0a2fdbbc92418f8e3185806c0e53d5fcf7473fda04bada5b17c"
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