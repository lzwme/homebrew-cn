class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "0cc99fc3856198eecc75e1a9338acc7e0bab123e2c356ea88830b361179fa331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ff153e71b4c7f8dc81d4dee2bf79df96078194faf6edd53bd7ea40f452e022e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28d5112c1e957425bce82781e58a8ae3d3203f534cdaefd9bd08edf1d58062bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f987ede1591bb88ac90ae182cfacee9a0f85ccc9906d262d3575831d65676a6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6642cc6245997b53f4e704e22f8cbc4790f760e8f22441364dfd0102a62612b1"
    sha256 cellar: :any,                 x86_64_linux:      "c0a5263051b9f511492624e41ae3c6726c26e0162093826eadf6ed4b96097825"
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