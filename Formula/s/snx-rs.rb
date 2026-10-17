class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://ghfast.top/https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.5.2.tar.gz"
  sha256 "3ab9938f46bc844483213993d6115449183d5f850e8fa9bda1c12e61e102e241"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f89f6073e5fca2850c6721b2d4b19148fda93add8ea8898982a752edcbb4274"
    sha256 cellar: :any, arm64_tahoe:       "2d8e5ea04f1cfc0b19fb38a333b7d975f9cfa6cc0ef486030a7ee56f16487250"
    sha256 cellar: :any, arm64_sequoia:     "5f567fd865d607d5a45f961045a893a68bd5ef14feb44609298ca1fdc36e97a8"
    sha256 cellar: :any, arm64_linux:       "d531d25480ed513a71cc5d28d394f1883c184466c02f643d2fb135cfec1dd9de"
    sha256 cellar: :any, x86_64_linux:      "e4cc903561bdc04f2c6523b74a3f7fe2c767d6611ea76ea8f626306f448f7f5b"
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