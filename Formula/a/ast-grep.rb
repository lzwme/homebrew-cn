class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.1.tar.gz"
  sha256 "40c197c51235490963da6774c5c3f2d726c22d61eec8ff4bc412ace32da8f60f"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e94d86ccfb28977aaaa09a77b85b5c24ad69ae91c7fb4c364f93af7478fbdc3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a98b0c10d2d79b6ac3bb93557ec70c9f074ee0338e5ec0f4023419687c24c46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3681b944973a06cbc2e2cd4910e3de745faa5bcfce04d36319cd5de7884ab4ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2022270078cf41cfc797f6beafcd84eb21a043f5b9b920c3ca30b5071bbe2c8"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec875e3ea5e3a2bfe2ad2aea79b6d231d24003de2f6e10ff3144ed619adc405"
    sha256 cellar: :any_skip_relocation, monterey:       "7aa211c6e50879ebc784b0b3440186cc0680d926a9c2bd74830d34b56f5dfe0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d258e84aa50410f1baf93eb48ebfbc8af849343e1c9511d54722f561e92312"
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