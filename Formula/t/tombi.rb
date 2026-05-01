class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "70b3d4309f1fd0075bd1b6ef592a5e45b66fd0dc2a95a8b986205095cfd78689"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90cebd5460a2f1760867599cb827714314cfc2d8c6a6793fffc58b880d00f163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad7f718fc40fc3341a03c0f258977c3e35e781157bc4653757194edf068a84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f1cd168a49a141659706d01e09c04ba70b6002e3d791bfe7b03714b04856c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e261d0e98e33f743e2c14882300d825b9336f50e9174ba2e329e85ced1146aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0524ba0dc48c5b6fbabe69b0b835c51aea9e5fb3eba262f3bf2f925d182c83a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5d5a7a3e08c56ae5e2a1bf56c74f440cfc439d01b19d1ad95359d802261f79e"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

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