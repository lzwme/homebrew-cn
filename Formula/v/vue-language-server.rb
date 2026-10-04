class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://deepwiki.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.3.12.tgz"
  sha256 "5ac7ec99308a8ef0a14de602be448268793f4149692137c3e92d46b3ca1360a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c830a321b09cab7ff811c1a263c2ac9214898b0ab7e994c304fec76d5f5ac6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c830a321b09cab7ff811c1a263c2ac9214898b0ab7e994c304fec76d5f5ac6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c830a321b09cab7ff811c1a263c2ac9214898b0ab7e994c304fec76d5f5ac6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fe4a1579ebc3aab52df203d8a8c108387ebe0120d29090859d69388db06fe03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7f4182f5b92a73cb033b66ef65875bb027b3f9c7dcbd532378194e8532473a6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end