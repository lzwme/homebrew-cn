class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "7b6c1994a8c07e7efcfe50e2f60af1906372fb6ec697ad3a98a36a279ef422b8"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b41f6e43ebd96c6becf131bf2976b640749de2b1b748a15c3b6336848c4d71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e136166b90f40649863191cc502cf1caad3989bdb8a5927132fdb1dd3220859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a238283098bc517913705a43a6ea4acf8297ccac48640a1f9358e7483221e703"
    sha256 cellar: :any_skip_relocation, sonoma:        "be8007629d0eea309be1ba213264fc3755a2b6013df07ccab47ace0651abbc1f"
    sha256 cellar: :any,                 arm64_linux:   "707c5119b634b9bb5d266c008f3ae52ba5350c99ce32241fecf730a711040480"
    sha256 cellar: :any,                 x86_64_linux:  "5f78d7d975a83895e30156c9470251eb9a4c36d0979e2f19faf040a056afe38c"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
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