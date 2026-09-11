class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://ghfast.top/https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "55ec490ea7203497d8b771a5c5f224b037a1872693b14f56a885dacc5d30630e"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3d358ee4bef99d986a9d33e9edd4d25ce1ec98041bf9d6046ea57f0b0d00fce"
    sha256 cellar: :any, arm64_sequoia: "279c0a0710a898407bcb546e2027ba9a3c3d4fb5946d063575de216ae0a010d8"
    sha256 cellar: :any, arm64_sonoma:  "b9d3e2b546cd497b793d1cbc673197bee2eee23688c6164a7ccec1323e7598b3"
    sha256 cellar: :any, arm64_linux:   "292b90a61957d31129fc84d2d51ecdb83974123e38f2e79fedbe02d633e332ac"
    sha256 cellar: :any, x86_64_linux:  "35bd6aaeb32cafc957dc285b9d09c75be49929fefddcd2670f132e731b3148ed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "fontconfig"
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