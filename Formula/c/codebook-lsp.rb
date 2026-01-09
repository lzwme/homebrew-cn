class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.26.tar.gz"
  sha256 "ad6ea8f50d0a1eb5d501cfa2a58bac934c0b0880ad96d5c0ab738af89eec347c"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b751946c6742ca6d0e6ed7304673216afbc127c12d9bd0a47bce092dc2195a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e485048ecc10022279d79970c5915377c0cd1f4c5978db910c9aa678732b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0aaf4a66ff8b2cf922f5dbf107c8470d2f934d5b24e5d157b2d2c3faf2c839"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8042032f742cdd4f57a6fcd61b7e5078bc7be1d2f56b167647799df2d282731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f3c56b2475756f84fd51cf7459312c96c892c32456ddde943417794dfb436e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6442d44d8cd0035ec5352093245b59e022937ba53f1b1a563de7546d6e03e8"
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