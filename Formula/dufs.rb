class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://ghproxy.com/https://github.com/sigoden/dufs/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "bd77bd4d9a5b244703761e7a745c9b127a271612f24d076d99abe758e0130a90"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95aae948353c374d7ca7daa1d10c31c64df4dee863e488ab38e8dfdc7b8c12df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e5fbe5710807d363d82bf71bfcbb7875b48f5ed937e5f4a6052d6186039c87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "996db48fe5e7c31072afdd175e8ea676b905a968d779216a9aaa3c91a1b217a5"
    sha256 cellar: :any_skip_relocation, ventura:        "c802ba09111d0bea6c3bc552d7c65e3110f79e479c2f72b48c59281216f27f45"
    sha256 cellar: :any_skip_relocation, monterey:       "017e6f33813a743f8f20de62bf188552f246ab5a7340f53b5f47ffc8fc57b149"
    sha256 cellar: :any_skip_relocation, big_sur:        "be5e9f6a00901704f0a4b9aefa010a894fabf69f794423574259d732904cd55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c29ade870d0a49aa072a466521edefb1c9765c94688e5e7b7ef8bf2e813d31b"
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