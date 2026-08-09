class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://ghfast.top/https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "9c377463a9be4211048d78bbdc4fb7312a55c5ea30edfcd78198a996c3f3bb52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc087c97dc32af538cd276d5de673a4c67d93541c2e2c5ea177bd3557e5672f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc087c97dc32af538cd276d5de673a4c67d93541c2e2c5ea177bd3557e5672f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc087c97dc32af538cd276d5de673a4c67d93541c2e2c5ea177bd3557e5672f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "503704efcddbdb51f21cb640614c47479bb03dd86b36259f99227d3d51d40299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e6435f627e08a14cd8fb3ecabc7c8d98db154639be697267ad921b338e82bf"
    sha256 cellar: :any,                 x86_64_linux:  "3469a4cc3935b059abdeafdcf257fb721dc714f2aa307b9ca30a44abc5cc4801"
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