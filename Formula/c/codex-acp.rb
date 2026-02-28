class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://ghfast.top/https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "fdda3b8b8e37cbfc8ca2046acc3a9f491c70cee2ed7a52624b1c550b3ba260b1"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72ccd5d313035da642ff75d0f4af9112a2a737f03885f2fa1d5723754803d9dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc6db23a2575fafbf16ab0413451fa2c6464cdb51f1c2c0f666391dd4707ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9952daea6771cded9646ffc4ff10f43069dfcd271d8569fb3941d61f25ccc04"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dc7296382b976e519fb39a3ecf1d121d8df4d1d2f5fcb0947bd368d92a9cb8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49cd30cfa6ca6393ee03e5724ecd472ca9de94e69ebf2795b19f7b764b873709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad7f4dcf3de465e7098e076693d40da0e91370516d11a9bf17a804b57f00c53"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.close

      line = Timeout.timeout(15) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end