class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "ba78b958b950e95bacc8d57a75b87773eae6d098831a9a63d29db97db378cc2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b84a3107590652ed54809e8c2badc7feb8f5cbc1dccb252caa18fe2531c9efd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "625557fde2223697846ddec4cf75715e5a4b5669ea1160ab734e1637c080aeff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "186d18e37df85bcf35a192dba37ea8c1faba32ea200d6bba14a0046d5dc9f62d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22c6fc553c77a9b72c9704b69f9a6d4356e73d533faba9586812acdbc9dd3428"
    sha256 cellar: :any,                 x86_64_linux:      "dc96822cb82b98232eaaf99fdfb45cfbc5655b9a10420aa90c1ba066dfe6555c"
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