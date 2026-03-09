class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "5d0ea952adc31b6f49f7e90bcb528c505ccd9b24b07b0920e64aa3390ac9b602"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c73fcd9147044a82403e9ae8420333e89e990187a37afe77d98beb9d6b0dcc8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae5fcd0e4ed8e9f306c706f52b1a4fdd1cf6384fa400764931c9800387c452f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13408cabcde6bca59a54e2b803d8297d2b585d5f8d72475a5c7914c8b18971ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe04a697144e0a7ff4ef5bc0d4430f39c488fdc4a8c3a147ea6888fe957ac1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57fe30c53ae3615b190dce1a342619ecf79ecdb49cac04b7cd244e5deeec91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c559d93127ef335c8ab98848d48c990e7e8fb45d6e960db94dcc8167f7e28d82"
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