class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.29.tar.gz"
  sha256 "73e3f2b08088fcba9bbe61fe57e6574b94b60d6cb995195aeaf5bb0354305165"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "742eb269d7d4297654a0a3726078265f43ccc0556aae1d5a1553a36dfb1ae5be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f77a0516abccfa56c7120e73bcd31d98052352ef8594defc99d3654be75be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "601658534274594548a7394c469ee78ab834407244b20c46c5fabfd21ba8bbd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb244b8d8786247234167ee7b93b5115e4980f74c0c55e7cf9bd5feee09a01f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb72d246e66da3163c593183f530a9815d7bdbe1bf6e0ffa78896e6f6c8d3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16d2ecacb5eba4554b25f21bcb09a63e1e361518463aa0d26a1150c3d329c55"
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