class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://ghproxy.com/https://github.com/sigoden/dufs/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "996898f6f85add5d3378e3a54bb8ddb2f51cebc6b3f169d5d174ebdbcd2c6732"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5718bddeb99fcb91778775cce73ddf0ebc614be32f70a1a8a8d08c02b6767f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "373b91e69b023b79e181dd6988060b3b298115335bfedf64504cecc7585cc761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34a2a713123932cf15f2ef44fc04db988122ebb04e64c5e537d1bd89827fbee5"
    sha256 cellar: :any_skip_relocation, ventura:        "ca1d6dcd4885359e0ddceab6d3b0f3f73f6d39ed9dc5ed339aeb1f011863ce5a"
    sha256 cellar: :any_skip_relocation, monterey:       "bd6ac4a8b59f1c37d566e511dc0c948b9cf742926a86115eb52c3eae015f21fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "84aef3bdbec19d2daad76e95992147250dbf06588a906b822d70ad7b0c7cd1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f180126d2a8074a60889571d7166175cfeb5caa8e03ff7a77b050457a299b20d"
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