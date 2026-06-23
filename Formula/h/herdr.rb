class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "6c7e7b1eaefc50a63a66fdeae681df994b528511ce5e1aa2ac611f8119231946"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb89dac512e28dbaa1857c23d4a80575bded2cab75cf2c7c1ecd79c41e998cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87df814f8d91ddeea7d838b6b454945de57ddfdb609277e7138ab44da020f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01525f161f76fb8c74a9ea630aa29f95063e9637777f35f7b3760fda90889a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d7c5a7fceed4c4b5d7620a10a8573f6b2b236aec6e44928b6af0fc30ee4719"
    sha256 cellar: :any,                 arm64_linux:   "3b0be1442fecb6273b58e224ab5b1417f35d1b229e3ec77285ee227391eea260"
    sha256 cellar: :any,                 x86_64_linux:  "7b0e043228194718794b6019c69c13624bd7640f739ca1c76416bb19a4fb4998"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

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