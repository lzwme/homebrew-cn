class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.38.0.tar.gz"
  sha256 "1377cfcaaf0d42c9cb757ab92a91b2fd84404944b194030fda7b4d5180d6fb68"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a215992af0c44e45c0f90351c5acc90bc4b62bd22409b1a972f42e58e0b2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13263be7447662bbe2c14f8ce41e3fc49608099f7620d3b4a6820a733511ad8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17be0a136f276d11549ccd7b0f5599184f241136c2120a4d288bb904cc427d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "2452cbfb4945c18a3671b8fcabee4c7b51d463dc1133a460c860fd5775caac7e"
    sha256 cellar: :any_skip_relocation, ventura:       "0e0ee05b1d44a1f52698143c95d694b55fd6ffef46f826d7a9ec08c296352fff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a85d66ae3994b62a3f0dc3d178b5c2dd0d896b8331d912614dcfdb2cf5313b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf1ddc2d47731163d3d40bb1ddc197cf805e1ce4e524d8cd88eac7ae9bf0d1e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"ast-grep", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end