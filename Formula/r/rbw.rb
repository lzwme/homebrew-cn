class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https:github.comdoyrbw"
  url "https:github.comdoyrbwarchiverefstags1.12.0.tar.gz"
  sha256 "41c54f80a970e22d1f236f639d6e1901fd7f3ccb46640122793ae789c602fe66"
  license "MIT"
  head "https:github.comdoyrbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "133244159359bd8f2ae3dd02e2bbeaf7463e53cbd7855ac7195c7de8c3a0b7f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76d43048b92e7c4dd731b474d0a16d92c6cbc56df6ee9eed280dfd124582ced8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ea68af7abed88f26ceaa4e02785435ccde909a796d91e347b37126bcfd25553"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3f1ca1ccf66bac79d164e968b2c1dc5eefda3cd3a200ccfc0c7b7a4766597b7"
    sha256 cellar: :any_skip_relocation, ventura:        "5307911b467bce3801013c3c803f81c36302d8c4bddec0caf2b18deb9d25c31d"
    sha256 cellar: :any_skip_relocation, monterey:       "cb03ee8db22498a952f92c610972759aef7bdc7e36d465b04fd549d3c51843dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d6aed6e7491bb1688a1e7641dae4af4d8269caf261f6186e532e16e75007021"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}rbw ls 2>&1 > devnull", 1).each_line.first.strip
    assert_match expected, output
  end
end