class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://ghfast.top/https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.8.1.tar.gz"
  sha256 "841fe4042e53f0dd748ebcc852d295271bf23a1da39adfe067ee98009d337be6"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccc5329dc292d9b7fc66d0ac568abf7c970d17e5d0c9e8d38b6128662a5e771d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df7074e69cf8bf87f8ae75ebc6e282fdcc5a73a6ef86cb6ba0469052e73fef8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f01e5aa56ae2f837380619f59da4a695af1f76f9e44a8475c1bd87c60999bbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "70863bfb38b743e7cc8fa4cd16855a4dd124889539b6f17d62e6bc60cead3a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908c7be84afc6317ac5f6e4c0261b91f99fec6fe982ced2110554e45165d012e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4302d838525c0b70ba27944869f637e51ea7a1d06065acf3c674ca799da2fefb"
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