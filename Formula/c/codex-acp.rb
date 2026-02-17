class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://ghfast.top/https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ee715faa4ebfefaee87ecdd4b06238d35693823cb7b907b08e0f7e39e7fc0f22"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2620c73b1207370940a10bac36f3f5d4ef42eb0ad6d538c5a6c453bf7971c4eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ac82abb3db314093d1a81ccf5cd5dc37c3a8b32efd4d5811d09bb05e0b7255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06af616a8f3903c2458e44ccfd78ba91facdc8c4d52edb355bf02d161ed76d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1310b4ff76253425bd06a0fad94413232d527cbbbeeaab7d9130c6bf32a99c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b367f3127108bb7250c8ca200b461b13c0d40fbaa4e4d7df89ab5cbc553cb350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20bb849c51cc7fde5c51d88e136bcf02881366a6fc2fc9f18924efe85ef00222"
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