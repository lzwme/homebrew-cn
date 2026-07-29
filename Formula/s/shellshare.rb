class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://ghfast.top/https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "4559e7d2e81ac1f19ce8eaddaadcdce375e18cba1f970d4f1406cc62d29a267f"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "187d8a12dfa4b5fe40a25a1fef03f18939cefbf0a004917f7fe300a5ede2a846"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99a68ddd43f3ec21e351fe7bb6446dbcef104d1d95dc6b79d177ef96117e2d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e09dd147832279b8e9f166885ba61c3d4cef6d2de153a762d159874d3e06411"
    sha256 cellar: :any_skip_relocation, sonoma:        "45947b3640c4b1ba7318aa080690d6db2115fa547bb69faa39b9b49aec1caa5b"
    sha256 cellar: :any,                 arm64_linux:   "0a64b8bf77f535475a9b1d8088bdcda8cdbbf8862feee0bf077919a32b93ef59"
    sha256 cellar: :any,                 x86_64_linux:  "ffcaae0b16abc9c15ea799dae2543b137cf7d80dc859be15c75a099b398f13b1"
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