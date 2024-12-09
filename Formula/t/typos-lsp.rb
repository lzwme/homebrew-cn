class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https:github.comtekumaratypos-lsp"
  url "https:github.comtekumaratypos-lsparchiverefstagsv0.1.31.tar.gz"
  sha256 "c90b515a2e64d4262405c4e6cb6d445bc20e1c18075f522c7e53099bc0937e3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f670dd7bbef1419c4e2b0428e297c02daa0a54bec990f8302097d75b5f78eef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46e060eed84221ea3e74ac95a6ff29191f70710009de37e58a0e0f9bcdd04d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95afdcd8391cbeae2f9c5d2b06af9260402caa677d49fdd7fbdb8557f2b09dcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5534f2768af24775679f9050f4f4f06370de451bb003a7434aa41025dc9e076"
    sha256 cellar: :any_skip_relocation, ventura:       "f5fab7aac7ae9f154218c9a636262de84fbc2aac741e05b0f86369a42e103834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21666d14a478c371f23598e0122f9eb91e966c5a9d4d7e4b46e5cf752a72e226"
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