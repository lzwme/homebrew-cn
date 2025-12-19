class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "996501862423d549a48db158bfede801829c60fe3605ca85d7ac2ed7d0be9b45"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cf29978c3f5d7a3ca71420eaec8d179ec6c9af4266fe6be2c1c88ab7f6da509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8816091aa5b112b32cb380b97f33a8dd825657313a3419718d3516f3102a8b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1045c41d59b2bd85a84baf9ff150b657446c1eb7c607f00b9edafc2dcf4270"
    sha256 cellar: :any_skip_relocation, sonoma:        "f87d218338058910b6df7509847273b8c1d7dad6de183ccf0b4f4771fa744e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b66fb536a11ef96c08c1781bf2af3e30a99013ab88e84e5d5655141e0563e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4966dd45f361471ade9420c51eabe0c9ae16af2d38e8cddabf26fde175077c7e"
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