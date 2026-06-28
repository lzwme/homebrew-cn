class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://ghfast.top/https://github.com/tmuxpack/tpack/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "840942602e9b939106f4ce437b10f711976feb4666c687133c92622f5230f164"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a09b4d50694982e43ae67798adf40a1efd5b970409263781692d78552671274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a09b4d50694982e43ae67798adf40a1efd5b970409263781692d78552671274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a09b4d50694982e43ae67798adf40a1efd5b970409263781692d78552671274"
    sha256 cellar: :any_skip_relocation, sonoma:        "1016c0f4edf4056126377b7fabb9600b5baa4e8b040eac057e443a54396a403a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac99438a38463d840b8989cdb25ad671c0744afe3e024fddae22c8046db2fe74"
    sha256 cellar: :any,                 x86_64_linux:  "5457e0fc2c537249fd88acd1cafa7b50fbad58c6f52068b23a577d6d724f8bbd"
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