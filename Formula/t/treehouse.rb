class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "297b59712437950647193b4891063f7461663af5ef6966f501dc70700db54901"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbd84f2ae084860546701172e99960ca67d5bb91ec97d2c8711fbf6d0b09d357"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37b404bb94793179772aa4d6aa02f4bbf8e2fad883b305f468eedc3036ed8440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ca8ee4061a288efbcd83c04472a50e2386eb2fb432390c4aa4db1bc93857c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c5463b08623a2f170bb9c121fb8007bd7b4b8773b0d8294c9545d5169f79fb2b"
    sha256 cellar: :any,                 x86_64_linux:      "9eecdf0ddac65c5cb1342976c79840193d86bf78d15cdb2c2f7c7a2dfa3a0540"
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