class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "0694d6e65f18ea46d509e08084867036ba9bc5c8ad2f6e4caa8f4a498adf9a34"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9ea9f1ecc02816fe828876a60b2749ddee8736a07dca8a91218e6de33103e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c8c915914903c5118ad778ef13361ece3868498095322a2bc33364763803ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba21431d73e0981a95469a14a1ac253d1cc0745b55f6c8e6387381ecc84b678"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff9b14ea74fa4b4f8f72ef823d956cad3e7af5a9dfffcb3a26293c905807f36a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c39876937d4f8491a894a101fc52a19a33cf2a4a7200aab286ded34893ec56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29211bbff15fdd82779e59bc60961f44a718438436d142be1c4efee570bebd24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
    require "open3"

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

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end