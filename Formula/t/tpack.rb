class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://ghfast.top/https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e8783d5e4d6b3745bed716ebc57104adc3512f40510158d46ff80d98063a1d67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6694ac3b1847c525588bf8cc7f5412cbb858c3a5d2b1f0fcda8954146b4c6930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6694ac3b1847c525588bf8cc7f5412cbb858c3a5d2b1f0fcda8954146b4c6930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6694ac3b1847c525588bf8cc7f5412cbb858c3a5d2b1f0fcda8954146b4c6930"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e0356d5f8c149101d7767ee571ab651017c91a3eff838ecf6632fcdd9279dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80789219ad13da5dc2eb2aadcbbfc53c945670c9a06313a99d97fba256d5d075"
    sha256 cellar: :any,                 x86_64_linux:  "9aa340a718c3ae369f83c0bb163d6c913b5d04b26cf8d64c6eca9a5af8a36333"
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