class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://ghfast.top/https://github.com/terror/just-lsp/archive/refs/tags/0.7.0.tar.gz"
  sha256 "000d991957f3760a4a674a2542a9bd1431672000c677f5294546ecf31f316c5f"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20e3e205501c126a1844f9598a4c53ec2ec25334dc2eb1fc9d1554fe269ea991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20e07010d93132da8b44011ba8c7a177a58d010a7eca73f3793bb61ae8f801d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa3b059d031f17150ff8b224c979d4e5aa2dc471ef76e51155cfb24e5410bd00"
    sha256 cellar: :any,                 arm64_linux:   "6c5aa25203d4b3d54f98d5ab099fa5135e492aaaf2c6ec139ac927e755c4bd6a"
    sha256 cellar: :any,                 x86_64_linux:  "649abd7b6aecfc484771d5ac544dbdf3cd077ebfae6ec87d8c4a648f33a08a6a"
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