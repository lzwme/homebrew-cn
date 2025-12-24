class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "4afb701a56ac279d9d1005f528b078924c71804f59a29462850b569ec81da04a"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e911551cfb5c9cb54d4fa362ab9beeaa812c42c7a119534011959d7032b2f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8421562c226c6a5425dcb9e80c4e77cbd1bcdca6b163bf8b2b086ccccf67a3d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f379466e34af37eef7c98278e4f81e4e3bed08bea054a7394ef740fa6aa5d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "67b008d6f71beac2cc773bca50024e9dabf5f5b33807b2b206a5b944c5d3c77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e35d1625879b05f24cd522a403c5c94be2b0c71f63f18c82c61ae837dc0bad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b4f9645a9191c2f7cfb37b105a1955981574642f37a2c4577bbb93be4cec9a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
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

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end