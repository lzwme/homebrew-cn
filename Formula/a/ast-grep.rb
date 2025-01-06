class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.33.0.tar.gz"
  sha256 "34f9afd3f1916c30ace514ff2aafe8c3a8e0d71afc3fd36638808e89e280b0c9"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d3c0097c3e165d0bbbb37b6481e570ce70a69450df15607dcb58830ac360d79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a4d13c4f0a18fda19b8a5d152c9784d585c74a0afeda325614609bed5c526a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff4d5defb4766d8872df454027ca3aaaaa97d8ee50da226707a3ee1df033fb87"
    sha256 cellar: :any_skip_relocation, sonoma:        "76962864882e83d2b401c12519c620574cb15362750b287fc808ad385689cabf"
    sha256 cellar: :any_skip_relocation, ventura:       "264dfeb235c7e9f20e13974be4de0c1986bc5e2753463bfad5dee383d9cc37d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b861f39e6eddb0ffb5e91b0f9ad3d3de2d029249587b345060e380610f5525a"
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