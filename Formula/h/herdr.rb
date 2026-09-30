class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/herdrdev/herdr/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "e48f6706440c92362773663131ef5b524c62549523e50a03f2b55d315edca100"
  license "Apache-2.0"
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60bb9a282c9350f100aa66d40f416b1b07892670e3a91489c039d093be6953b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca0dfafae3aa89abf46bbbd26726ad4813deb4f784f82fef851b75b2330ebc22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d381e8af36dc499593101d33b80098dd7316ba9f167b1535e4eeb76b2ac2e58a"
    sha256 cellar: :any,                 arm64_linux:       "6b9e828aa918f11d6c5c27dc7237fb0a6c4a3766edcd76e0725f273fca2d3861"
    sha256 cellar: :any,                 x86_64_linux:      "e3fd0aa811dc08c55f19d26dc71feb90b2897ae3998aad895ad90ab397f7cd02"
  end

  depends_on "rust" => :build
  depends_on "zig" => :build

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