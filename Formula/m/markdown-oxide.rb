class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://ghfast.top/https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "98c7337ab0966c37eadf24d7af6b8876ad6d9e7e0a380e7c872fded40dd569ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "312cf903363ccfb6379db61a3cc35e53cc94254085d17f11386e931fef6d23a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d126656923a055db9cc0e32254216583184a7af26aba9afbf73b64f5b523aeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "197773dbd0161116e4028264c0127f2be2d17db4e7c0e8dec99cddda57e4b692"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7c2f910e2ac479213460ddc428f2a8fab88cbff9913939b1ffb1cc3fdc06c78"
    sha256 cellar: :any_skip_relocation, ventura:       "3e6daa7769988692856ca9de960dd0fc9d037632f143e2e978e2976418be823e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5d74520e66752fbabf9101c14bd74dedad1487cf04786ae5e4ef2ead1ea6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6901746563029c8310f8f8c932055cc14581bf5931092c19fa9dbb9cd940cc74"
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
    assert_match(/^Content-Length: \d+/i,
      pipe_output(bin/"markdown-oxide", "Content-Length: #{json.size}\r\n\r\n#{json}"))
  end
end