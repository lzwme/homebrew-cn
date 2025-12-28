class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "bfcd7474757fbe9e0f53e4f7e9b57abc7167000834a8416635bca638980989bd"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a47e0e04c160c60cab99ef5eb85081f878fbe0264cdb0d01e3fae2620ea98ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b68820fdcb0723d36be3a89c83d480b65277e66febd128907eb2dd59ce40b3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443ed802b5ff24368d2193565470ed5656be181aef28b584180d014eb331cdb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6595bec7ab07bdc54d8878bb5134a8b27442dcfc27a973215d50391dc3dc1a94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "250321591226ac4eea007d5f421aa703dff6267b206714e007d03cf6531e571e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba8a10fe514e94c6bc4f9bfb26c77167b5f5b95953ce747cb8e7c3289cbf016"
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