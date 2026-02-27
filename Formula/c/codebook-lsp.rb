class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "b8050cd93e4ebca3a1a9096fb82e862513151fb3a7c3898e7e62657d1a297212"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df03a1bb1ace0b606dcff7cad53289d1e82a35bf01d3f55b3aacf301e46d62ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81e557ab25cebc4df5df272c1d67e4c08698864efb9e007950a0de3a0204d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b8d00e57626bdbf076c0c261f789d8428d269071b1b0bc0edf81de091d74df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7671891e6cd7017679a14fe06adf29ff1aa7a30ff3cbb6a41b2b372b41b9d129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1202110b6b276f7ce51f4ba61892a832ef264c10bb3e8b87af38ff476b67d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db2cad6ae8c384e89eb7fbd28d17116a5d160133edf6b21a28b9c88bf44d86a"
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