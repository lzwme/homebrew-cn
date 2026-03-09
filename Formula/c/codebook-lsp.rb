class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.32.tar.gz"
  sha256 "f91b19ca180222320e4460783d3045e99427a4c65f806b958b920b5fe0b5d52b"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3abda2fafee9490098aff0338666848fde8294344333a58f2f9d80c3d713e619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f62fb564fae8fef9139b2b5e5f41a2edf4ccfc11afb18154dc9578eb99eca98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b943f206a92cf2ee416a7747a365df85031adf98b357d11baceeef1dc0199e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "026a396e48499e3852e6646357ad28963099c070ec0703198bfaa11c0a8d80e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "588f67cac5aaaa24ea0d94c8b91014522ae9d0efdbceff77b354e32e4afd0b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8f1ee7ab2baef63d1b58a9ea619d1d056eb8900e68e7f3f39a22adceb91523"
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