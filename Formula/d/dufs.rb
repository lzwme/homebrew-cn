class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://ghproxy.com/https://github.com/sigoden/dufs/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "763e29ef0e6ca886d01f3974d8b0f3475eedf536eb3600bc13edf6fb6f9fabb8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a655be01245f56462df32eb1228a11d8a1914d6e43fb287c78055bf322dc960a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c0f1e96ac24087ad6200169d647318ca89c10959e2573716185a4b003ddc329"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6731e505f03c9d252c8cfed90deccd674e98571a506558e9f11a1873e42d207"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb05619ecb107a02656183048f54848abf5b85852ef8b60453ca9b94278259a"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2c91c53abe5ac7b2668b0f963f1470a542caa8b53b0aff5ea6ba487a1edec6"
    sha256 cellar: :any_skip_relocation, monterey:       "2913ce448503e7563a5f022a8594a0872e9beee1de3a55970629b4937877f02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3143eba4cbf8cff90b0c0289067f736283a95b1a4c21745a0f6b74dfee22ef28"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end