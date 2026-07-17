class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "d10c246c76108a781f5b0592a6886e94345e078778e19206f5e6ea78639d149d"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f1c9bd95ef4e23bec61467321c8679c717b318aafb28260ce9cecb73c6f158d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640e943b02e3dca4bf0e2645de83d99b119ee1ca6abaf559087d7119fee9bde9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "832a3e9086b2d77b1b0f03076d0f7ec822429d05a944e52c13bf8c4d15e9b419"
    sha256 cellar: :any_skip_relocation, sonoma:        "60ad76ed8e3f134d2df94054b149c2b14242458270f2fd2a01c5651726e3f548"
    sha256 cellar: :any,                 arm64_linux:   "79a18b6bf7b5c33d168503babaf2ad14bd19efdc0909ce78d529f0fb511c7ff5"
    sha256 cellar: :any,                 x86_64_linux:  "162feb39f269e0d9061a6241b0155dd1bc0a2d9451ee712cda80f2a9eba90a81"
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