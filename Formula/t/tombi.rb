class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.34.tar.gz"
  sha256 "1505d8ae5f868a8a710ea976121471f75fc7156a00e0d12f33808a6ac6152c94"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b552e6eb3661e84adf04a9f2510a1577273efe6ffb5c1386a7824fb774226f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e0e19245d82c3a539aadc74f44c2dec0f983079c1dd8efaa0d7a37aff0c5f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b9c4ea691ccc86ab0d11bee10e0ddc651f1f4540846947691ff6f1d56da2c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c09a166cde9d0f7eb337712558177e68f5bd972f0da8e4a2da9a9b0f947a61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6096bede03df8ce4c7e0ef984deffae7a7e9ef2efa4fdb499ebdac30bf9f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41457b8d05690aacd4843a756b29daa0efc470db71451cea361601a6860f59de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end