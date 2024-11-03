class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https:oxide.md"
  url "https:github.comFeel-ix-343markdown-oxidearchiverefstagsv0.24.3.tar.gz"
  sha256 "ef7cef6461bcccdabeefb1150478a19091453a4477331e093bf7082f5dcd9588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a20cc29a79a286727f1ae989d09c22b785b02a97266b78a734267dc13daf5c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec9668c37b791320bb7699575fd41dd4d1421a8abb874639391bd741d82883e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42922caeaca02f5f790f645e4b282eeee475ad8885b693013f74615c77fd05b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b65a62ed575ca28406130fac763e2a5bcde35fa4e9f528c74f8698989fc15b0d"
    sha256 cellar: :any_skip_relocation, ventura:       "a0392d95b4fe36178adccd6c86fe072683c0ccbeaf6356a9009d0965831e59cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33edb5480b51fc52c144d8c4952bdeff096e78f5e403da8feaf09680a47f930"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
    assert_match(^Content-Length: \d+i,
      pipe_output(bin"markdown-oxide", "Content-Length: #{json.size}\r\n\r\n#{json}"))
  end
end