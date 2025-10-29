class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.40.tar.gz"
  sha256 "cd3e0b3cc0118e8faf0e86f644c56bbfc228fcd0a17dd0c0c96a235c3acff0cd"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01e80d450f98be2324cd6cfba4c02d6b0091b377d4b38d8d44ac9bfa6caf0b8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b67720c45a4aa0fe0fad5dd8ef05329831d28844e5a6be5bcb623ff9d09fdf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9e095111885106ccff827dcfbec9e2b116e0131f25823598eba4fb0a73179bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce20cd67df4fd3ac684014fdf386d17303efa9f513109692f820b79efcaa59c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8f856258b58aba373c0885d154230d0cac0a7122cca454b03b697139bb5f74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a138c1bb93a8203aff0169212da2e1620934833840076b66dcd56011adac477"
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