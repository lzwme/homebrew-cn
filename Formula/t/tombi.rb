class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.27.tar.gz"
  sha256 "8b4c96388984724005b72a6913c4a54ed403c8d38887a4a15714bd67c74e548f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec9d0722badd99a5470e8774f424e11416c61ecb94576d9a519209596aca8117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e0864a4c64905eb5cdf385b4a2c7fb2d4ba6ebd33b77b8927192bbb88b74e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7635b6ddd9a2762afa868b67a3cb171e9be531432a926bf4f815126b0d6421d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd720ac48e80084d204ca4bb3846917384f894f7e3cb91b90d271f4db37fef06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "734d67d99979410917a8e4433a35dfcf3acbb9ee8565935450b85d5877d4694e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23aace89963638d2a9c032907debe7f87a4a33f87155dca2c1040ac23628d75c"
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