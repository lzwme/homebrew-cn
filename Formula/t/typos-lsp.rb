class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https:github.comtekumaratypos-lsp"
  url "https:github.comtekumaratypos-lsparchiverefstagsv0.1.30.tar.gz"
  sha256 "176db7e46c135158d385092547d1cb999de7420fb8b2e0b7a491ca67af6faa56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9732e4320c0cfee13fbc845ddfe382efd60c06eba5645fb74f49c6d35badec83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c84aaa3ce4889d53a139a093aac178deb71a4816d983c9a38c0d5a63c65f793"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae43f7eaee667284571dcb599202f3682d9625fb23f1c75177939a0b634a805"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a858477adfabd87f9414ac76b5905e1703689a218930f8d9fd64d4f13625834"
    sha256 cellar: :any_skip_relocation, ventura:       "a9cd5d73df7dfbd832f99ae6da110ee3749d777a755fc56a0b83cdb92078624f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f00f6af3c783f468abf28a640678f17da966c815595de1d4225dc9db62857f36"
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