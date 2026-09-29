class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://ghfast.top/https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "f07055dbd88867b849bdbe47bba560ad2bb0a87066250be408ddbac5630e579d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69c0b11cb2f145fda0323d3c5ed6afea9d534b624e26af8e26cb9547f4c44b58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69c0b11cb2f145fda0323d3c5ed6afea9d534b624e26af8e26cb9547f4c44b58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69c0b11cb2f145fda0323d3c5ed6afea9d534b624e26af8e26cb9547f4c44b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5cd3f3e1ff3914e3e43a28b58d6266108219a25d56d605db2aa9bfeac2e0a4f3"
    sha256 cellar: :any,                 x86_64_linux:      "c3536c1b2d72840c73f165f2731f8bd575b46c65bc2a317e0b7ffeb92c7ce450"
  end

  depends_on "go" => :build

  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/lazy-tmux"
  end

  test do
    config = testpath/"lazy-tmux.toml"
    ENV["LAZY_TMUX_CONFIG"] = config
    system bin/"lazy-tmux", "config", "gen"
    assert_match "# config source: #{config}\n", shell_output("#{bin}/lazy-tmux config show")
  end
end