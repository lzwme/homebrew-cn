class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://ghfast.top/https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "c9e157b27427a645c5eeef51efef00e97a3988e1838f11c1cb47a18bd6e29ebb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ce0bfaa449f7bac913fcc8b137b87246cbce65bcf30009d3eca7b7093264dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212d32af6a62920ea608d24909098de5df80dac940533316b0edbd3eaf91e8cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "846201fe7a32dd9f0a86a71bd36ab6afee5d84b8880cdde2d4e5e270dcab42d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2de85f4f5eaa14006f815978a02b6aee8db653afdb72646e6f5417043ec82e5e"
    sha256 cellar: :any_skip_relocation, ventura:       "5367d0093a4e3bf1db84b47256ac6aebda8e641d3acc7bdc7cedbccab6e2f46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1f3bde1dba33b8c30fb4d920aa67eadd36ed649d081b1093ed8650970365c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c13641a49e8f756bbd423d349889b300b993928312dc2da767ecb5759817f7"
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