class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "19ef0112cd85ec2b598fe4957c80638ea6d7794881da4c437f5d272e6e81f549"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cc33e26270ad0bf55e6b0839312c4c80d52760140a0b4feb5ea8ba8b0c6fc91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbef642bcc100d8faa7894b4b521d9f9dfe0d8dd6d4b54bc7a6e560e87bca484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c258e0490712a767c30ba823958eec45853d549adef298906a1acf01dedc1e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ba862a618027f76fa15a81c631d22ef833303ab96446de85d3c59fd50a808a5"
    sha256 cellar: :any,                 arm64_linux:   "c478676a264224f8b7d744259bfa94bd9a641c110c96bf2d6760be45a2d181db"
    sha256 cellar: :any,                 x86_64_linux:  "5de2559e2bcd4ceb65982faa574f609f0fd5c6544e1d1d9aaa87fc0927affbf2"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
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
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end