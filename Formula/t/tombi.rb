class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.37.tar.gz"
  sha256 "d09a01ca8c13d94b223f47632b4cb6d41bf77a24a1425e277d7abfbaccd9d3b5"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "937833b63de323c9c28ecb3b8c67be51d3cc310c116ff40d86d26435cd9705ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c126b5b8ecad6ae96a07f5f097fae3e051b5ea44b80f2c4b2215c2778c2c802e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d6f27962c33b744b9e08ac80021df7a01fc4e680677c5d118a96fd9ed935c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f833bbc426e39d9a0303a63e11ca18fa49cb679688774698893241b5b7c7fc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164a47f45b3a057db018a184eed7aec0e510758e9ee97dddb556d945eb3a00ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74d910dbbdf60ce8e5eb99165dc1fb4b6b35fba7aa8b6dd018b81b49219ac52"
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