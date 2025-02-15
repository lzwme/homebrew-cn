class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https:github.comtekumaratypos-lsp"
  url "https:github.comtekumaratypos-lsparchiverefstagsv0.1.34.tar.gz"
  sha256 "b0dcca9542e2f3dac44797f8b7a65125e4475e357de0fbb542256121d6a04453"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4efac892b323f3b32e6c07998b59df4bf4946f52435c2d5740559b1f96ba42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ace77bdcab13f2597acf0a1f018a64f9e0a2c1c15be9e1efacadfad9b4b86d8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2013fe60cb003f82d1c09e7856d5ab29885a48330bb02bd68d938dc5fea6587"
    sha256 cellar: :any_skip_relocation, sonoma:        "9379c79303d1dbfd94170a43376b740fbfbd2df4a850e4324c0a9b18ede82a94"
    sha256 cellar: :any_skip_relocation, ventura:       "0ed108e42e612ea642fc2c052c95556641d9a6bbb0cb3f596e3b459b91245163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330fd6536ecaa21879399b08bc0cd1e1136813b4c5f9fca4998f082b8e6dde0e"
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