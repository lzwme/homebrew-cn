class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://ghfast.top/https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.5.1.tar.gz"
  sha256 "2a45296fb4fa4f45a15bc5624c8d4ab1265d27c7d6c9e9e373f765d3cb34e37d"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "20f41eaa1d6ee271490a2bf9753ef9ad2681b49bad737f26ad4e6f7a71606581"
    sha256 cellar: :any, arm64_tahoe:       "fd1a80e55cacbc02ac31f4e085a32ab37a7aa063afd35679bbfb5d80a1466d49"
    sha256 cellar: :any, arm64_sequoia:     "3b50e3c0be60d0e273007e287e349cb5b8ac50616fac8261521b37f25aaa247c"
    sha256 cellar: :any, arm64_linux:       "e5b6d88b83afa2c9a3a183acf9566f4c64e705360bb11dfcca47114aa12eb96c"
    sha256 cellar: :any, x86_64_linux:      "46637a2ac08c556f8eb40503d64f7ab7c76fd7ae21fe3db142a2c6bb16a64b6a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/snx-rs")
    system "cargo", "install", *std_cargo_args(path: "apps/snxctl")

    # The GUI uses Slint. On macOS, enable the `mobile-access` feature
    # for the embedded Mobile Access portal login,
    # since it uses the system WebView (no extra dependencies).
    # On Linux that feature would require GTK4/WebKit6, so it is omitted.
    # This matches upstream's macOS build and its default (non-webkit) Linux build.
    gui_args = std_cargo_args(path: "apps/snx-rs-gui")
    gui_args += ["--features", "snx-rs-gui/mobile-access"] if OS.mac?
    system "cargo", "install", *gui_args

    # snxctl exposes completions via a `completions` subcommand;
    # snx-rs and snx-rs-gui via a `--completions` flag.
    generate_completions_from_executable(bin/"snxctl", "completions")
    generate_completions_from_executable(bin/"snx-rs", "--completions")
    generate_completions_from_executable(bin/"snx-rs-gui", "--completions")
  end

  service do
    run [opt_bin/"snx-rs", "-m", "command", "-l", "info"]
    require_root true
    keep_alive crashed: true
    log_path var/"log/snx-rs.log"
    error_log_path var/"log/snx-rs.log"
  end

  test do
    assert_match "VPN client for Check Point security gateway", shell_output("#{bin}/snx-rs --help")

    %w[snx-rs snxctl snx-rs-gui].each do |exe|
      assert_match version.to_s, shell_output("#{bin}/#{exe} --version")
    end

    # Probe localhost (nothing listening) and fail fast without requiring external network.
    assert_match "https://localhost/", shell_output("#{bin}/snx-rs -m info -s localhost 2>&1", 1)
  end
end