class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://ghfast.top/https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "233e4367643c3f4f048e6f65fd47d60c62e80081c492a1ab394b57786b94cea9"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cebd94ba8493232938abf7f385e2847761446d18e66ffc0d87195c9894977ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bff03c40ca1293a3062effc6c151e6ab1bb526b9e979658e7362cab2a5a877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "012e30df558f2c0f8188bb547be0c112f318148e64b97cb6f701b78700231d12"
    sha256 cellar: :any_skip_relocation, sonoma:        "69179c99400fe3f30beb0d97c8aeddb502b906d98136d4bb56e643b2296642fd"
    sha256 cellar: :any,                 arm64_linux:   "736b50b985ba36e59f682f941f8bf58796129609287e1ca4e2de8b79c1671a42"
    sha256 cellar: :any,                 x86_64_linux:  "0604aadf86f2ad440f8887949e6fb6411e7211b4e7643f40885386b162f2cb6e"
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