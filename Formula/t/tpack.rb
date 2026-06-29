class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://ghfast.top/https://github.com/tmuxpack/tpack/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "282f417361e93f37c8cc9c882559d84c9194afbe7eabdca654352971e7955bf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac478dad38e5c5bf71a383ba412171e334635997dadb31895fde9a64f7bafb6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac478dad38e5c5bf71a383ba412171e334635997dadb31895fde9a64f7bafb6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac478dad38e5c5bf71a383ba412171e334635997dadb31895fde9a64f7bafb6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e5ee411653e6727e00882ccd6f8410c3adc041b2daaaeffa293ed3a98837cc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f01234ad7afa9a8dd68c47c533e861e8f8033c3ca5107c834aa07d8d82f66466"
    sha256 cellar: :any,                 x86_64_linux:  "5c072c2074185be5d41d196d1227e4f45a48263efe4da7de24a45746f738f02a"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tpack"
    generate_completions_from_executable(bin/"tpack", shell_parameter_format: :cobra)
  end

  test do
    socket = testpath/"tmux.sock"
    system "tmux", "-f", File::NULL, "-S", socket, "new-session", "-d", "-s", "tpack-test"
    system "tmux", "-S", socket, "set-environment", "-g", "TMUX_PLUGIN_MANAGER_PATH", "#{testpath}/plugins"
    system "tmux", "-S", socket, "set-option", "-g", "@tpm_plugins", "tmux-plugins/tmux-sensible"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tpack source"
    assert_match "tpack #{version}", shell_output("#{bin}/tpack --version")
  end
end