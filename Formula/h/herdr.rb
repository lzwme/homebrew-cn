class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "86f4ade98e4fa048b99ad59d1453da00b691dcdf559bbd18441f495b448c02fc"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef132a8d1d9676971e61224b7a111c21303b0dc682f27ae702a82ed708e7e559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621c5316d34723c3f990079357c76192f998fc59df8a9a08e9977852ba513bf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "290b942d16a2d5f3d5b8b8aa1f63085b518616c86495279095820492d19dd128"
    sha256 cellar: :any_skip_relocation, sonoma:        "05048cea0dd1aa3d6417f4b5b1259b92e83629e1985826129934b8e02b1978c2"
    sha256 cellar: :any,                 arm64_linux:   "9e49b23d28476e2f8209cd2ee6cec4384be332b0e4c46f2210f6d315560b2ca4"
    sha256 cellar: :any,                 x86_64_linux:  "e8bf75cf7ccdd1aa73a242869836fb0bdcc06c4cba9bd322ae6bd42f0b2c3353"
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