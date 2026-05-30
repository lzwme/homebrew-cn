class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "2fbae009cbce588f2bfba81f88ec0ecf0e134dae3a9e6f35318afcb8342fc215"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbd9bf24ec15792e3588dea99eae1e661068043e1b5e27c37cd85154ae7dfcea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b3c26246a0463462cf2be339f69bb687daa5f391f32cb42414fa705d5bb257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fccf84dca280e56fc77786607316880bf6b5c1c957ba789f956e416dce7e803"
    sha256 cellar: :any_skip_relocation, sonoma:        "0542f280466f3eced417405c5147e699e3ff1d178ef7c5e8b12153b89c28e2bc"
    sha256 cellar: :any,                 arm64_linux:   "168684b9cc16429118d3fd2cef4178c9aeee8ee4862edb1352b1d7cc9cf059cf"
    sha256 cellar: :any,                 x86_64_linux:  "ef7e9b4dc13b5830ee1ab2c40c9e3069018285396f191b4724a2a8faa97c7e99"
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