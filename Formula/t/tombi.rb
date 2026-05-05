class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "97c3467f7a4228e59e5dea4440bab6a5ad46057b170806ff654cd30bf5f79947"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3093b206984851ba06c5918a5f5a29b8e973b9b9e7188df9e9d14adaa15c5c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91bd6684b4eef114fc2042266f279fbb8585e8fa156fcb09342178ee6c2bfbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291058fb2656b1d0beb0ba1b7cbd16f088c15e0c3611ead268b8247c437091ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0553759bd80c01d0d83f0730aaf450e22834c415132964fdf3e6598c86e6ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70338180f2e0377efe75b04da2d8b2be9383c53ae2c1dc2fc71f4df9c14d056f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14b1d5d301bcea0cddcd960764f0412e33cd178c178ef11060ad37b308bf58d"
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