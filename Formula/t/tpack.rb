class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://ghfast.top/https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "8ef0854e7ca5ab53adcb259d8abb98aba1f3b8c2a859c15023c032309ba4b314"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aea32d9120118362f79434111beb6f7d9e75c2686fc4c8a5025c1e73d2784f5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea32d9120118362f79434111beb6f7d9e75c2686fc4c8a5025c1e73d2784f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea32d9120118362f79434111beb6f7d9e75c2686fc4c8a5025c1e73d2784f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "76cf938e7ca1beb9cc830c3a3753107e845649bc160edf68d482ba86383a7f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1a4faf8a1285eff25e71fc1f701b799a0747000893a4f7157e19bf46e8429e"
    sha256 cellar: :any,                 x86_64_linux:  "43101cdd01ef00b6396b478d08ba9786d2a8045df0f97dca4e7266a8485418e3"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/tpack"
    generate_completions_from_executable(bin/"tpack", shell_parameter_format: :cobra)
  end

  test do
    socket = testpath/"tmux.sock"
    config = testpath/"tmux.conf"
    touch config

    system "tmux", "-f", config, "-S", socket, "new-session", "-d", "-s", "tpack-test"
    system "tmux", "-S", socket, "set-environment", "-g", "TMUX_PLUGIN_MANAGER_PATH", "#{testpath}/plugins"
    system "tmux", "-S", socket, "set-option", "-g", "@tpm_plugins", "tmux-plugins/tmux-sensible"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tpack source"
    assert_match "tpack #{version}", shell_output("#{bin}/tpack --version")
  end
end