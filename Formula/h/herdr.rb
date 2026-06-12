class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "6fdb1cfe62ea89718c12e32ac097f5e35c1e223b5e3e529d1a7360295c329518"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6810301b200fc9c98968e664a90b870ebb1a0f1330c5275f63d8211d159881ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd9abd785077d9ff83374b143e4aed2a09476932eaa4ab1c7d27e70d9c114dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5fb5e81014e8129869cb2662c4a74211280e1b0e23e947499a2ab0a06c28eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e45d18955db11eabdf0c2439f1b45c9029ea325640ee1db5981c419bbe0cad"
    sha256 cellar: :any,                 arm64_linux:   "a4dd597c81f39f6c796530e2a8541776a92a1eac50004b3c035e49b05d0cc9b8"
    sha256 cellar: :any,                 x86_64_linux:  "6a00bd55508debe5ae3b5ac8adc013088a2139fa43b93a5e739da54c4fe36598"
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