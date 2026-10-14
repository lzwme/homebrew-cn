class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "d8ec342834270bedb6ab33931a5ef8ebfb2ac3171fdb9d4761f4a10802be9955"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e482a9c8060fdb3037e7ddcdcd7317cdde2ac60892cc311e39d3e921d4bcc381"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6452abeaeca6fb88ef23378c8a4bfc4cc5b250d90bb09bfff7188f5c67cfc245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d8a3b5b82b2c5b884e923840efdc55b3f3709768571b8e0fe27261d8227fa12"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed491ab38000913ac3daca20ae64f3c8ddc30ae520d4fbddfdbbd8c4f39f57c1"
    sha256 cellar: :any,                 x86_64_linux:      "4d17905044e0bcf797694a03d6aefdb30428a187332f4dfe3204486707689aff"
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