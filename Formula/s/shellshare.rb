class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://ghfast.top/https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7a6aeed3c4ebb22476c3319ecb3d825d40fad73dd7166f35c898ea8e2fc28dbd"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d004c3dfb51f2e52fdb605bc29ba7de91d03c71c0d8fbc0f7af105b4335c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac36b89e705984a640795ab0672141720fbc09982718127490569020911ee1cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40ab02930d2a39f06a8d9b5faf64a99f10a6989063a83a2e940f5f719fbeb42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae5cfefe2c414bd611e00bdee454bdbe00e2588f37bb17454cc9e922cc4a0173"
    sha256 cellar: :any,                 arm64_linux:   "9289f704af969326dc873eb2287425f9614f909f670c38db20ff4935677ef15a"
    sha256 cellar: :any,                 x86_64_linux:  "5ae61f7c7f82a439504d487360d66bd212638687a4c6bf7b40aec61daf49aa2f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port
    pid = spawn(bin/"shellshare", "server", "--port", port.to_s)
    sleep 2
    assert_match "shellshare", shell_output("curl --silent --max-time 5 http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end