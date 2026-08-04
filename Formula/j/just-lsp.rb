class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://ghfast.top/https://github.com/terror/just-lsp/archive/refs/tags/0.6.1.tar.gz"
  sha256 "70fc2fd7c1a9c7dce750a7afcd03fd0c830dc922722cb0caa4b71e895b2c7df4"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba7303d82a299c159b214632ed1ad3074e405c78939c5c586e352f94124503f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f8c6ef73d1b90a7fbf58fc5e69b7769f35e43886af316004d3c3f64605ce56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052b12bbf261707c1198d167054f08300796cb134845e74bb5985d0ccb40211d"
    sha256 cellar: :any_skip_relocation, sonoma:        "894755c19c1a032f43e6c6083a0cfa8e172e136a2c92166797ded6010d611824"
    sha256 cellar: :any,                 arm64_linux:   "b936293d61457e219bb7f98a214a54ed089593d16414d49e71ead59918bb5c41"
    sha256 cellar: :any,                 x86_64_linux:  "3223715123d41e85f31096a4c80e792c1e868ddec12601845c258940a7ed457d"
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