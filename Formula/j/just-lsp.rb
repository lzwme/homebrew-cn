class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://ghfast.top/https://github.com/terror/just-lsp/archive/refs/tags/0.8.0.tar.gz"
  sha256 "b4d4122b8698f47cb80912d274d1abcf00af1a93d7d84cc2f0d84e8f32596782"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6827b83e195723110379ce84c197683f29bc066885dc4e23ae21a64cb1d24d39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f98a519d1d0356dabfb6e37d3d7efbc1a9d8a2d41a62c669d17882fcce1b7cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b1e3f6c2008ac9c29d86f1177377ebfdcf24f2484ecd9e727b925f6895be04"
    sha256 cellar: :any,                 arm64_linux:   "bc2667bac80a3f5279563893575b1ececddf768d455f826f8a7e481d3f618848"
    sha256 cellar: :any,                 x86_64_linux:  "6d431328a4713e3a86ced56a693fd7dad63b75b12705caf2b03a9d4e3bfc424b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/just-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"just-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end