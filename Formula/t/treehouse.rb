class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "471acf369b3aaf01c718c82617cbab603ac1f23e8c2f214570ebabea52d36428"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80c8da80e19edab3bbf5f36bc6988d0e2b97f9d0de65d3e5e247354ed24c0b66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ad6868b5a798a8afd66f9fda94f82006c39f4c0f8559c00394e57c8f11d834f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48c1d34d6d5141c4db48e34029c5e4461b50b566e24f9855b770437f98e2e51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0abe07c3eb59ff3f5dccbaf368eab6038a02c57080d8d5d5c1473af9e53d6ede"
    sha256 cellar: :any,                 x86_64_linux:      "c7b8e8029627c2cf383a747fd8b1a44025dde70e81641320939daf75874ea4bd"
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