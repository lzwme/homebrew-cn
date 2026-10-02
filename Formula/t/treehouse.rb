class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "5c05e2dfa67a4c185ceabe5fab189c6df70d224a1f6b40488de54a52702bccf5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c957ae82f79bfcea01b69d2b8c576a51baa01ff4e858ecf97a0908ebc7e1143"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "999159e1a21656e9b07ef46e88dcda012bec3cf338fceda5fa6eb055cab21172"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2da79da76add7ccfb4835923ca324df75623d6f7794aa1292ef30629c58534c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1876e12b291595e14586c0d2560e753fa16109a4b0476b63a603ce9316440d9"
    sha256 cellar: :any,                 x86_64_linux:      "491ab5a5625bc5f0c5c85cac30c70387d5b7a2fbeca936820910009d311e49b8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Homebrew manages upgrades, so compile out the self-update check
    inreplace "cmd/root.go", 'os.Getenv("TREEHOUSE_NO_UPDATE_CHECK")', '"1"'

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"treehouse", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end