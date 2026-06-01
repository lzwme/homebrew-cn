class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "1373df5957819541b15889c1b88baf97299f893da7fa5ceebcb1203e30d9a84a"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0594da30f0beebca4b183e9e09cadc3de4d165b1eb029dc6ba16a94dbd75fd25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ab3559b816470a47181815cb736981a34ee7d9c2762d8ecad0a85189e31a748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a73c51c0d06a64010aa49fa3973a876f0d2579d39f88648db4fba5506ae0d20b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e6e1941ce39549d54f68bf306f4c74386323c5a44207dbd846403ccb4a848e6"
    sha256 cellar: :any,                 arm64_linux:   "71b914e210ec4060924002a02ce9e5c32387280de4935a9925165f70f6040e0c"
    sha256 cellar: :any,                 x86_64_linux:  "32dd543fd7fc9e2b3f98690b8a98e199ed49a0510930d4efffbdc9ca9390d422"
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