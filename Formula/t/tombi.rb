class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.28.tar.gz"
  sha256 "e5d09d282ed380602b1382158a0a7d0c4fc2a2c4cfe9858e9b8f23d42f60fd82"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaba006a42b85aee0f9ccc7fe444328e6d17038767c6485ee54564a1b9e1da01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bab238bc63eaf5998a3ad73d355cf2552d7c99ba550c0694d9d597ae32f7e920"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "352308e94b8794337acf2e71a547780a159149bb4b1a0e38674e769266a17fb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e5c1df06197abd1468a60ee4788e1fbbc7927f1aa93b2274bba0dba19528b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9295058cad2a44c88b040763fd6b1ecda853dfcc33b9f36ea35a48872ba66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7286818309c11b36837b312fcfeff4d794d5c624d9cd39a47e8995d5ebf819fb"
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