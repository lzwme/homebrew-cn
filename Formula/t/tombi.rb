class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.33.tar.gz"
  sha256 "4f6027c161d3da6aadb81488a86a3b4f9030bac94cec7437e5eff40cc65254d4"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53574c91c34e948b500bc59facaf951add21303735a7f9bfda8c1a8a0c82f98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057eb31fcef410a1e33dd278a11b5b36c29c66a379ccbafa6912ce80dba32243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8200c378538f71fe23a1cf16123924afc5804625e05422fccbb2bd76eb1f9535"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca9c73388b30704c1c4809ae41e4259f52dae4442b751dfc0f998402a88b1fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34b7fb0f68e846531a4c41cbf4d3d06dacd610bb5b227b1f6065cdbafbfa0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c83d82f4820e9446b8155849c53189c950bb43de69b3f9655e36ea4587720a"
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