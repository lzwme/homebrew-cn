class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://ghproxy.com/https://github.com/sigoden/dufs/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "bd3cdc7951c9822369bd7b5c6f21a2bfdf2f85ae40fb5e02832e4e024964d025"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da262d49c6c7b7798acb4d99958b7d25dbe1e6fd4598200b3721c6be42245364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6113fe99301104f447cd0383c1cce4e008692b422569e2af349283e8bfd74af6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bacc6c329597b1e981f14964ed92276090ba2d03befba1ed5c5083b049a08f2"
    sha256 cellar: :any_skip_relocation, ventura:        "3a816f9cab04c2fcda39a43e03752830c0ac99fc5d4974149df068ab4fa37d26"
    sha256 cellar: :any_skip_relocation, monterey:       "c162ce2d009df28e7270b9b0b3efe16492860d3bc2bb925eefc91292187ea00b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f7c5d238e785916aecc670fd242a9d1c5ba4770ff13eeb463cd93ce5fe76adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38eb32ff27ee29e402b032f4e4538291407d1ca9b61c5cca0f83636da45e1491"
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