class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://ghfast.top/https://github.com/terror/just-lsp/archive/refs/tags/0.6.0.tar.gz"
  sha256 "2561ee156e133e377a262d2cf7ef5cf867aeb1eb46a4c6f95a92c174f8fc7f07"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a9f62fb78891c42b8e3d0141c22431644012aa1923035756de81692b0ff3108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99ed1ba486002facf1e0d26cfbea5f5ffc93e6bd8b7849f7f1a98dc9de5e1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae13f54806cb839c03792b3fee82fdec397d331e7eac482375e73b6d03ea929"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a611e5a03a9ccc330c25fba09940d449c2cac98075f00573a0d4fb8d12c58f"
    sha256 cellar: :any,                 arm64_linux:   "c30cadf2896bf4d3ef27c42ce4843fdc910eb5513fe1b071c09811f62f7ead72"
    sha256 cellar: :any,                 x86_64_linux:  "18387e6f33f55989e5e752f1f59c0132bce84c7c7e3bccb320d30449f3080cd2"
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