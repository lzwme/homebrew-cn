class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://ghfast.top/https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.5.3.tar.gz"
  sha256 "c68c14f02d009d33884880b8bbdc64a1cce933b17cf16ca60f8a0a833e5b9e29"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f83f3ade31117d12eb9cb2093362491e3a47ff4ac5db823faf93a5c39037593a"
    sha256 cellar: :any, arm64_tahoe:       "836b0d1370c87ea8649767071dcdcee845b2b8fbe01bd909c22858b52098ca8c"
    sha256 cellar: :any, arm64_sequoia:     "0602acfcf0de6ab6cf174775d8c30261086dfe82b73e1e16419906714db46e0e"
    sha256 cellar: :any, arm64_linux:       "76c555359892ba2aef387d4511fc0025514da9a16962ce17b0119132be13c572"
    sha256 cellar: :any, x86_64_linux:      "40865a38c91d45686c9672caf979156f616468f56c586606a17a2d695447f900"
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