class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "ded43f67f4efb4a0bc727136c15e4aec1d06e4815e2f0079dac053b7de924288"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0e68e8383f4fda70093e22aa1a9c51e0d985af2411108e5cdf58495457fe711"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "142ae1f7ce2739427e22ccb64fd47953f11b4bc24593da96b6eef9ec7e1fc17c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00b9f4431862199309a4cdbfe9cd1aa0e7c69f1f83a5bc6d5e4246903e2c26d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b12d52875ee79ef5b38cdadcfd76f57fbf1f1257f32f97a335d829f0d13e793"
    sha256 cellar: :any,                 x86_64_linux:      "80858975bd2d6b5e71c9c2b64e6ba799909e2baa383bb7e90705e4f4a86e2084"
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