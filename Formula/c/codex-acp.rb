class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://ghfast.top/https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0813038f51360362221ea8a525c46b5de6272659bffa63853391d6e264f738d8"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b372648c7ca1aed83b6ef5046924e87a638ad5718d3fb55b4f1ac0cf24848f5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "078e2f5ed2a9374339b2eb1534c721be45f46d392ae55c620a431ae8b68164f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d5a43d2877bce8d95b877e196dd82ca1bbc4e907af21b81a9f9711ba3a2911"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be014f4a149fb2b156e2192bc5e9b9bf55ad12d6ca26bef5ee69288cb440827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "480416e516fe0c1a55ee79a7519f20c7d1ccc6270f14dd82dccc913a03e35cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5584b4627974e4e0fcce3b8adb06267e53a13c2748bc5afe951bdda1cce49c9"
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