class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://ghfast.top/https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "974c0b30dec38426cfe7526a0e9b14fe88600b6b78a741fbe273edc91eaec8d4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "649ad90d89fff278872dce372331b13810835220410de5ad18300182edbdca18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7520486cd416562b19051969282cb009b7c6755132756e7bfd5d58fd9ba03f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d2948a128701e4cfb04bffa47365a65fae7b44ed4d9d220bf32dca7d01b74b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eff2d0b495bad4e0764559753ba8260493307822c496dc89aa9926bbe32ce38"
    sha256 cellar: :any_skip_relocation, ventura:       "012633665cc77791b10253bfb38fd0d2c6fe53151f4f115f09536da92d15f430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a80c5ce7ec653e44e4d608a839eae5e8e68cd99636d2691b8e3f0885131a8b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6e2fed13e17e6af8cb7e9cd89ee1e07a2184f84248edbc286d3853f648e591"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
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
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end