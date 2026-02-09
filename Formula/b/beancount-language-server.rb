class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://ghfast.top/https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.9.1.tar.gz"
  sha256 "da59c3e699f55cd21d8b178f279ccca6cf3fd4865082cccf3d8fdcc3b95ca9fb"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1f5828ac0b1a29333b7d12a7e8079fcad3673a752594a94fd347db28ea4b5ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d30ad7ffb613561477e52bfa5ad903372599ab400ab6d76112379f99403bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2394fb52b69df9fecf10e868feb538d2691405cb3d8dd210c4cb034a01a13be8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca63990ca2b0ec53ab3f24891929e8144357d0f85548a3ee6406208cfd3255c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90831e2a53d696eb15dd5141aaf93f9dba37ae228090fb4d53d15688b3729b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1494cec40cf840226b31e02c10e9fe7e8c5a6201b7b95e9bfe155de60a2c88a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end