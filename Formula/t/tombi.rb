class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.26.tar.gz"
  sha256 "07036b7e31e8c36e2d64be7a5b56c8b7ed7c4ec1773f231f0336c51cfdc9602a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fd66bfab5adad60b26b80f0ef7562920fb8cdd2829d8a89698b431cebc2c1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844f836eae78013add2e9394d6a8f446549cb4fea7d48e886ba31b6f842d9425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91e134ed786e9dfee0e8f49c05d675645fa6c8ff86de444c2ac4777e28c95d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e6ab8b1a701c880e3289cbb277175c364a52c9b6fa6b849b30c063f4f9ac311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "118ddc3b8f56c551a5dfa7795a77978324db0f015e6902bd5285c0a8b2945dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07015252814f760626cbd964c3e9ee32e7e6b79b14aa9b31d9f927f105258353"
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