class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "b91b5c3958f4d1b778dcb21203bbfaa5af0c654a6d29db64ad456ad30517ecd8"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3c4d8b7a5fb52b18573ade01146c38cfaeb8e91b509742b917545bd157ef345a"
    sha256 cellar: :any, arm64_tahoe:       "66fcc443d4f159c9dddd0bcc5f95f9e94d27c5dcdfa44d1760deb7060cb4f776"
    sha256 cellar: :any, arm64_sequoia:     "7077fb837eeedf9f941c477f6cbd5a93992066420fda2aca538a06a7398483c8"
    sha256 cellar: :any, arm64_linux:       "298ef8b674388905e9c4b8ea4492693425fdce29a717ecd492bc618656972703"
    sha256 cellar: :any, x86_64_linux:      "282cc4a1b103e9f04baf338ffc1117a0f83b359379fcf07deb0465adb2ccc6a8"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "tmux" => :no_linkage

  uses_from_macos "sqlite"

  on_linux do
    depends_on "aws-lc" # cannot use on macOS due to openssl symbol conflict
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "web" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
  end

  allow_network_access! :test

  def fetch
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1" if OS.linux?
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args(features: "web")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = spawn bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end