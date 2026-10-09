class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "2da687d59726f8c9a68741d09dd01bdcd591d752e5de47c45e28702d30762850"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f137c265f1d9af96b36c6afebf383501a5d7db826fc5baf93ed9577f715a683f"
    sha256 cellar: :any, arm64_tahoe:       "262d1c91c12492f7f80a3803e6c4631111bb31b3a2f46440ad103c47c6a95631"
    sha256 cellar: :any, arm64_sequoia:     "8de5e5a7a0b1871c6f3d35685412785656d2de44c4eb06c4b8a70248c96703bd"
    sha256 cellar: :any, arm64_linux:       "b760171509f836de746c4fb65eb6aea65c77df301f2dc98505ee2b91f5db233e"
    sha256 cellar: :any, x86_64_linux:      "9e112e108dc112ff1294ad2700302bf540275cf66d444909f1c1ea1e879b551c"
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
    # Keep the tmux socket out of the shared `/tmp`, where the sandbox blocks connecting to stale ones
    ENV["TMUX_TMPDIR"] = testpath

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