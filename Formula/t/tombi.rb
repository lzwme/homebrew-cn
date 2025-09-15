class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "80f03c08562155a2dd5b92715b07d3601feb21fb206c42d5aa090df9bd080672"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527dec7c252e98ed6cf3981a2b37493221e581e6cf59fee1594eaeb93a0b52d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8489b90b10836f0497865b271cbb1f71cd07bed464a7a32af7ec6d76d7bd0fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f22a26b9e4dc9e514bbd708bf9f86ce71d9b1bc546fa56ee6f8a9a8b443beb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b20d222e97d47e4a3764bb7b0afb935558b319d4b194fa69265bffcd029cd38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca18199a565b64136724f14bc5caa04c161e66fabe9b45d17e1bdd9f3b46bd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07fbed81b976de070a6408e3167b46984186705ebcf07c9092b02567801ea094"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")
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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end