class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "47ce53fd08970bb2e1b0f96388cea3f1702ff03fb3481bfe285194f3459f6eff"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "614cf03b7ec6bb84a32a05ed94b7ef663d3b2aff83bf02bec84d48dbfc902f38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff8b97637569046cf355ead5c173ce5350c093ce2cec71daec148d5104edb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a1d7c16b7f1c6e35106ba87fc0ffc0fb07b6bf7305ca640da6fd9a58480b19"
    sha256 cellar: :any_skip_relocation, sonoma:        "50d16c493c996963f8c90998aee32352009da63d8ef9c409b8a85e8c139be081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec881b486477626ce9112f40c0dc83a27eab8a1c26d9ec05ca36eac641f640c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7266bc180acdf82e21ff7665b88d6d78be3ffd458af339defbc02774432c562"
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