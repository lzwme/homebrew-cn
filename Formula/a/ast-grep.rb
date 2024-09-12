class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.27.1.tar.gz"
  sha256 "440229b2565ad593ab2c138092f484bb472354af8a73ede1b6df884758389257"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "94a3a5a35fd509d7d52a1235739f1ed021e5f9b985e034b50bbc3deb84155518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c7a0de94bd5f4a45da0f39710e8dc79478bb483e0c47cbfffc1c50ccd76dc0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee79a975b82f4c159f9db7cce3da56baf55b6e0c5d7877b08c531fe59e680c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccf23afbb0f59c20ae55bfc5a4bde97e78f7284cc13366206fe2eca5d7b809ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fa57ec05a2cdb5fb55beb18a5aa464832845db7d7260f6221e892fde8ef9d51"
    sha256 cellar: :any_skip_relocation, ventura:        "295eae199b84a3757a10175417697b165aeb3105ac3f07973bcf1232014c357b"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa9c6748c9df2636de18d7193a7a5eba99419ec58a14618a3d2b80bebbf060f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5d14f4b722c25599ff88ec938610a1163b472d3d134a833b8337b5e4b376e8"
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