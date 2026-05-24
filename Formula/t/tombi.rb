class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "cf29dd720547b863f918fddaf706ccde6ce142c3f02d6f9bebde4f11c18f5571"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c433b47069847bfe7ac6b6e5e50dcc214e17dcb9d72363f6041f113c6dad5fea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ef5ef851b2925c6046599e72b5f6ff8065270ca7d2b0e8f25e0749e04fc7157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43015a848e24c1b83ac35bad672fd703660fd95cf1777e6e7089edba1ac852cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "33d0188386260c9a0545a9d10a808a4da1bd6ecb4b3e4f1b83ab01376beefb36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076a18113dab529de364fbbf90f6437f6f505c6fcb450d1aead4be62635f9cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b93211401b0dd7f0138f4dbffe8b28f3506ec92c3a8723cc7bd1b9a69282ba"
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