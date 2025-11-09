class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.42.tar.gz"
  sha256 "97d823d8ac18014a5159fa28416973f54cf4be68547b2713a38b7e41acfe537c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118f654d0f2581cc10284b44b047ce163ed8ef5a6a4e6fda6c1dbad57cfbbb3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e7cbc51a150cfed5ed9a0d5930c4bbda2fafc74bf31aa1f13374d33e59be5f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c1e1ce9dcaad8bd8ea41aa2c8a08e3411de4090d716b726d27df13f6224f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "f49a6c3f69486de579978d35f71003f66d33302b377496dee5ca107b180321c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc17096cefbc28ef257eb45ce5aa8a52fe9edd7d1d7a621e2f2b2593df24f129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b917f29e02db58ddc0d2543e300af102e9630279e25f76e62e171b5ee94f712"
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