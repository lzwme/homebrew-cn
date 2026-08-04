class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/herdrdev/herdr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "47bdb0753beb8a6b157cf2fec26fbe6b787f85ffea0dde579b0001d6cd663572"
  license "Apache-2.0"
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "023371c558dfcef0c13503d226b79257697822f6b59e8d070af0ccece83c01a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f58fe82db8e98358e88bdcd69dabcdbf1e672d438c542009d36ed95f3a4cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68bdf37e1e66da0c100ec54c54507ac52bdea80eec4b8ed957ffc896a2978d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "e81347e18468333f406bd8866efb17280389d2ec374fb57cd8221b0a948c9e23"
    sha256 cellar: :any,                 arm64_linux:   "20711b57bd0b2c15fa006856aa60a17aa464d24f9ee7d1e47f9dd0ba567a4206"
    sha256 cellar: :any,                 x86_64_linux:  "0f84c739cb11bb592d8b1503c96bcd7ee052f8726ee6182ef46335c0dcadae91"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/herdrdev/herdr/issues/285

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