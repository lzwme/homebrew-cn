class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://ghfast.top/https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "61fd7d6eccf6a298ecfd5283074f9105598fbd89a434cb9f9f2d065b1ebd1a5e"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7aa1368b2492d073a545c6ad32bd6cf74f96e2caf51c9216002ac0f1b53af4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b23bd01f9a297d7880ad9be793df458ff1f52a776a878deab45a16aee349a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23fd12ccd423f75eb9ac765c87c7e36383da1bc91535b1fbe74d2efc0d3adb68"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b2e95f19aa5e5d6deb1fc0230bea1a4e92e634afa0a4ddd7150b4daaa8dfb53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bfa43367882ced324f3ee9550d7303597022b780d892a899181394a4ef80ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2130c4501bb1db5e300fb622195ee9216fbf9271aeac8aaed2c3a4176f1925d5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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

      line = Timeout.timeout(5) { stdout.gets }
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