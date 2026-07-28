class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://ghfast.top/https://github.com/terror/just-lsp/archive/refs/tags/0.5.1.tar.gz"
  sha256 "cdcd87b0307dbb1a77f8fb2755dfdfe487138cf98f235762fb035831ccf34e37"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e8d42a45c29c46950f49ac2b583f9a59b23a42371dd385e829214f95a2e2a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4570a822d094eb4da4f17728f3acbe4a10fae9f4e0bd3ee562162b902af7b41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925ffea26de0a67e78edbb18e868e183c830684a72b656403575f696deb05fce"
    sha256 cellar: :any_skip_relocation, sonoma:        "70a8b500b5fb3662574e06e1613ccc8e8cf00ea14dfb5e3c970ec0f5a489b416"
    sha256 cellar: :any,                 arm64_linux:   "3ac11a6a7c857929bed25927fa01bd0691132ac40c3be7aa790a25e3033a45b3"
    sha256 cellar: :any,                 x86_64_linux:  "2dce0119cd95b8cd1b416eec4a449cd2aec53792a1d2c9a1fc5849e0dac011d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/just-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"just-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end