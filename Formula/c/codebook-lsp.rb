class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "7cdc63b681154db1412f01bd081e65418c1bda4e58e4eead0fde99159dbac8fa"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be7738225ebec003bf0231a2c2116731318e3f1137b84bcb2c8709c46511963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0663523417434a93a1b3ef9adc13b6f8e2b8d0254f783c2d37398425824fc647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dfb5b3e08e772685bad7655356c53502c44f91f39c6c79dbbd559baaf7ba641"
    sha256 cellar: :any_skip_relocation, sonoma:        "27cc07ad1d1a0eb43ffb8a1602e55ac9851efefa1495df141624cc05a6342786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c46b5bb7d739ae77b041912c24660de23d6e5ba056f49d569fe0e90fcaba92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c53dca85434605f0b94807ebff36efd4f809faf6b1f0fc0908507084942cbe5f"
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