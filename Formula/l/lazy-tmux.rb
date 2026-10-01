class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://ghfast.top/https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "13dd63e54eaed31ea6bf875b57c7a4f665f13981f79ff2001c0f7b5b24241bac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7684eefc8a72b2fc4e9c2dac6509c3c4b1eb98969146ef0d18c04c029c517326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7684eefc8a72b2fc4e9c2dac6509c3c4b1eb98969146ef0d18c04c029c517326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7684eefc8a72b2fc4e9c2dac6509c3c4b1eb98969146ef0d18c04c029c517326"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f48f0a14020ed22862853a647d41c7f5af2bbddd6930d0129c02e5d2a8a6a8f9"
    sha256 cellar: :any,                 x86_64_linux:      "31acce335d756ea470fd12e184699a1e6b19f619d1fdc27ac3f2ca0ad2d619f5"
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