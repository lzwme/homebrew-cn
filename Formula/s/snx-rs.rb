class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://ghfast.top/https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "bc5d28e164b9a544bfdf02fab9d9cb3c0927ab205476d9909cbed418975ddd70"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0ae59abcdb05ee6ef712993a7c745ba132ab4917a0adf873b7bfbcd42fcc2c0d"
    sha256 cellar: :any, arm64_tahoe:       "8d01bd86296f3c0f0b7b45b3f95220c2fc2b02c4c71ec4cb822fd29d68d3570d"
    sha256 cellar: :any, arm64_sequoia:     "66645880a63adf2a2bb67b4ad3a3ee1ed42fdfa2c1dc32269d2886109c977784"
    sha256 cellar: :any, arm64_linux:       "8f8650465b81191252065fe7aa3c6c0cd07598aa88aa495656c44fb309f66e43"
    sha256 cellar: :any, x86_64_linux:      "f86fb9a9221fc109fb2b638c61a09a10143191585a1a6f2e472f92fc995b1bf0"
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