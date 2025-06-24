class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https:github.comtekumaratypos-lsp"
  url "https:github.comtekumaratypos-lsparchiverefstagsv0.1.39.tar.gz"
  sha256 "e947770d7f12b06886db41ac8a10fd5686c1dbb6042f9898dd899d0900d59762"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55403c7e7e0b2aee6be005d00bc8dc473ca9cb3848b28ab5931eccace26a9dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9428f821cea5fef7e817e3cb106ac1eef96d04dee9c549546f7a139b2aeb404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6f64174382ef096a1c4c2e9590a85134f16642f7db134a42660d99d4bfa71d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3487b5020d1fc296d44a24559397922ec77af24af47195dbabf5dca9642727c8"
    sha256 cellar: :any_skip_relocation, ventura:       "c17cdbd4e46a2e93baa472f9114298d5925a47d4f035b4734ad5f8268939d2d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f67b5e694960d10c2b2583b20bf05a0b5cac986d673000996540c6fa4842f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18aa3629a81e166ebf1570c1dae325c8954fc985878604cce3fc0f60014da365"
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