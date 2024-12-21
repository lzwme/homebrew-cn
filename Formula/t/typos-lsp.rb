class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https:github.comtekumaratypos-lsp"
  url "https:github.comtekumaratypos-lsparchiverefstagsv0.1.32.tar.gz"
  sha256 "61b7fa8cee440dab69ee87016cdef912a2b325cf3488279abfb6d76947a4ff18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce64d53bada813b76f302764ecd54008462709c8ec761712562b5adaac6b9c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6fd16c3bef5b61c22a61708e73a2f2c6e4aed58bce9465d70382f8673d6157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04a75b544fcdbe959db2054d04ff0b4a524c24036fa3fbd2fa85222531cfefaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd200c4fb826ee05b37699bbca0edb040e7d272f89532ed13d992ba3a1d11f79"
    sha256 cellar: :any_skip_relocation, ventura:       "76adbb943a02b77dcac920e7c08fb0b925ff282993b72d46220c5dca8921f38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a565083d499394469349e6a3a08d98600402d12c292cbdb94b66de7c4a16c25"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-lsp")
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin"typos-lsp", input)
    assert_match(^Content-Length: \d+i, output)
  end
end