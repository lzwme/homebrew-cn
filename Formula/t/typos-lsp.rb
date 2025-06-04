class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https:github.comtekumaratypos-lsp"
  url "https:github.comtekumaratypos-lsparchiverefstagsv0.1.38.tar.gz"
  sha256 "27e8c28b8332bc51a30e95595125f6f2f265b81a16f867808a850ca5b516284f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b9eb12f8a0c7ad5d86e24e02a07c910e6655e078dff6e1d388ff79d3cfdfbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b848aa4033ed6bc2da2bcbd98c4d1a1197a4b035d8c5fd9327e7f3298dd4f3e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba297c801ef04133beaadbb3cea32bf5abe7e610642fc1ceb1940c8812026c70"
    sha256 cellar: :any_skip_relocation, sonoma:        "51eef0b0733d6e9ec3a095d4aae29f1a1b56429ffb2147de9296ca604638848a"
    sha256 cellar: :any_skip_relocation, ventura:       "491914db885c600fce756b449902abf6919659c71f35fdb03e1d7db83a3b7adf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b1ad5768b5a791541cbb6a569adc921251766ad5415a6b4bfb5708df7d412e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c715e30eaacdccac5fea534a6d9c9f37039d18e36a3bd117b60cee3e5dd1221"
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