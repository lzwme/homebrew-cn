class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.27.tar.gz"
  sha256 "eb1ff8841930b6781dfae984e06a7202c113cc8b022bbed5ed898c477617dc56"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e77b1cb4cb73e7969d399b1a6d7d9e44551be963e5721e74b8358cf7d1fa5062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f139e1a0b874161165a5592ae1858bcc5b7f9bd1d810e15f5a733cb891145939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b611d441f32cbe99203008bc62454657505674f93aed825167b85a222372d4a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a17775af8d1f396a30d7cbfb0c95409ed38bbf0f9013bc72b15692f814cca22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22e1681f21f8bcd64d50b81e05241168bd0091cd8481a42cee2145e5e314b0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b91541de30c878f240ae4b35e91eaf8692c42938b58167e024578a04480885e"
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