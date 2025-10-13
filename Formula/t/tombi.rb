class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.30.tar.gz"
  sha256 "53672694d8ba72f3449478c4427a473954705ce80f159b958dd939d87c155ff5"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e81a4ce4cf60d4aef1bd591c56ba6dff51ec7469d73243363e81bed42e7d954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f300f97445775e872d7de2a9494d1e8506dcec383d2a20b0be84d51016cf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc93d7cba4f3c8fa1441e9e2579a9530d87ef9723b32b24448d24446fe963f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "6792cf6915387474f73f73b1c3ce081210b4885bcdad295c9a8dc7b76fee4e40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "538e5f50071921345313df014dea055fb6ef1ad94d49132d6d60561c115c5178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6849b1f44812edb18623f594d9822d4a4c01f175cf4e0a9daa8fa8c13e3431f7"
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