class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "b08f60b206080ac621cce40bcabccb0dc1e63e818b8a5a67e4fef9e3f59fd699"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "135710c78fef55695d8c11b64bbd08ce0761841e287446d565521b3ddeff555d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a70b9f1cdee3ce34d8b51dfecaf00c8a3314edde125d48d987b39dfcbcedcfae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f44cb0a7663a1bf6b501d35e32a80350c3518143b2f297fe3e0b8b12ee3ee6c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4390f3f4312c9c5fb9bdf2c641b9e7817dc48005e23009ebaef52c4f239c1ad"
    sha256 cellar: :any,                 x86_64_linux:      "73ffca84ce35b78e79f8074aeb3ca259894bc2db91d66369e8968abf74d39970"
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