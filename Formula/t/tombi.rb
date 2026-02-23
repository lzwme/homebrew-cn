class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.32.tar.gz"
  sha256 "c3e6f5b21b970160a404181eee94dfe6be779cf1232d32eb27dd0d3b93f29a58"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab1c8bc70691b152d049dc2c5403649e2311c7e7eb705b20a35ac0d24e4d230d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83066aa67446f17fc361eadb6d2a9b01949784ce4084187559e4609b0a4a3c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5effccdbd04103761338c2f6c4601e08364103028d9128c664f7e996a60990a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1055ece10f1703d2a87f1c6cf86055739355bd0bcd1996b0e4e4fbf7fe137357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09ec5329d6c94d9435f60ce6f9bf2bf1afd680c66f2736aa95c98af2752dc40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5020c4e7fe17e11b402ca563ea12eefb27d300d006ea6da4b4769969f9c48fe2"
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