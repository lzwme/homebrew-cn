class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "4f83fb17d6ce0796bf50b19ee4919806d55cdb66cfc7f7b5b5893d4f8978bfa1"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "330fb918b1d12dd4530a55a0f157fc50ab626e1f2313e22cde259104c832cf43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e9f16ecc99a650803d71e87c314ca68e61fa2fe34b37a40ff690ba3b9b32ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f694f6688ab089b6b89c613b3c98147edbd006f91652281e0ed470e8f56de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8866c7e34c48fba97ae5d3b16528b57743ccb5bf80c413fb2772a374982242a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9370ebeec2da2a4fe431770f455aeff12bba023d71c243bae66b76dd54ca0713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2df2d7c273ab2700f1c6357c895524b2f57aeac6d924487094d53233a95a1d"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", Formula["zig@0.15"].opt_bin

    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herdr --version")

    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s

    pid = spawn bin/"herdr", "server"
    status = ""
    10.times do
      status = shell_output("#{bin}/herdr status server")
      break if status.include?("status: running")

      sleep 1
    end
    assert_match "status: running", status
    assert_match "version: #{version}", status

    output = shell_output("#{bin}/herdr workspace create --label brew-test --no-focus")
    workspace = JSON.parse(output).dig("result", "workspace")
    assert_equal "brew-test", workspace["label"]

    output = shell_output("#{bin}/herdr workspace list")
    workspaces = JSON.parse(output).dig("result", "workspaces")
    assert_includes workspaces.map { |entry| entry["workspace_id"] }, workspace["workspace_id"]
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end