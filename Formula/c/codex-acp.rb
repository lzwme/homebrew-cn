class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://ghfast.top/https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "229e23276568ef1a5cdb8256780cf38d013e598e654d441cbeaa9c5d5b1d3440"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3d510ad1b9cd1311f52babd5113877c28b6ebc0103a7c0f1bf9e37d425ee634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06928f0f2ceb883f53f293438dc7ba06b371b0a26daa61032b09102f04059cf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4908630ed41bed63a1fd84b315e2e0f718aa32808dcc2245f628327637659839"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc72a5858cda13f6939a864374b6377f62d7af3115eafecad1bca2670b3b5b0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87730faba3f5a12aa98c737a1ec2f263c5326ddfca768df5cc98cec003859c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c2993ed11863263a7586cadd2229ee0ff83879b0bc225fdfc6fc71fe851d2a"
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