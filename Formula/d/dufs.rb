class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://ghproxy.com/https://github.com/sigoden/dufs/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "cb09973b94e2209fa2f657a903c4115309dcb3be2a8232f60c97486ce62948f7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6460c9cdae7efde16b82c408ac26fb611c7fbffc72f5d17393591c9cba3340db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "213bc86e0df37c39d9e1ea192209d1fe47fadefda7934f8e085b266b0cf0a358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa26b1501aee815fd897cda0a7a4b1324b1972ce5b81d5a0ea5e41d563d7ff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9508e866dfef650a9b5001474c82acc6bab673f5842233db7dc2f7ea0e82cc49"
    sha256 cellar: :any_skip_relocation, ventura:        "538e2e7826090d3b7c55a84aaf345bc6fd0cf96aef7d89d6b243b0cf401f6630"
    sha256 cellar: :any_skip_relocation, monterey:       "6f0d3c99e83a6db725c7f5a6e340192fad8f0f1ed93f6776b3f3979c24799d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d929e00b750dc9736b0ed815125ea42fd1b0e6d1ca60faf2cd36d7cb4a1e3b24"
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