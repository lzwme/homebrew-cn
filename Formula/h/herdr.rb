class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/herdrdev/herdr/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "ef44377e496ef674e72ce4084bb9cc5f0f52601a5688fa1708b4414fc88cb0b7"
  license "Apache-2.0"
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "302cbb66ba02820f547a14035443553232366dca260d6523fedadeeaa4f71565"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "759c28bd5ec340546cf65ae8edd45332582d7de4599124f82a8b96fccaf87d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "116a136d97fc887e7846c924646dcea92d45e9e97978be2500726eb8656987bf"
    sha256 cellar: :any,                 arm64_linux:       "46adbaf257860108cb581ec9b28cedee7c269eaa70dca25dcb0a29472da74f3b"
    sha256 cellar: :any,                 x86_64_linux:      "1781f55949674e0b05a89e0ebced8b6bbddc93dc75eb926a36453e41d7a45265"
  end

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "vendor/libghostty-vt" do
      system "zig", "build", "--fetch=all"
    end
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
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