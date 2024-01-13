class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.17.1.tar.gz"
  sha256 "76b0a681c313b821b4d4ca8ee8ca8604c1e61fa4dcc1a94a50b24c2fb8dbc5b1"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a79785ae6f8cd338a1a0d67711b1688974d9f92435a7e1f589a27fd2e80b10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a44dcf73f7c5c97ab2c25dc22bf0d65d44d31b429a71c5395a889ed588ad4cfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf5e878141a43986b052202a3302d37e6c02b93cf64b828285c57269e7f379f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e245811444aeb0d9f954f3a8ad1da360ae6e8ebb9584e9a8a217f1b9117dd46"
    sha256 cellar: :any_skip_relocation, ventura:        "3d71faf80d065aa76d718154824a52649454effd7cf396ac1ea07d8740ef34cc"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b64ddc9bf46c5ae0a04680d18ab89824c170180d559881aebc3406a1b50540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fee620270eca1932cd000a35647cc1bb4171415a10eef6c8466e182f49c653c"
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