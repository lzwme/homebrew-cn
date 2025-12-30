class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "7a919d149d7cdf3e38f5e96b95e9c0e250bb98720a5066972114586a0338362d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dedcc9e60245ad0a201d8dd33b58577ae44e468b36bf4deb36e4f4e5bc2e7f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf07cdf460d006cd5aac7dd41e082035a1367c2d0644edc828291fe1e648fb7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6abdb85a0ae0d487b39872f1cdb083e85f68570396482879b7ca1890266a6750"
    sha256 cellar: :any_skip_relocation, sonoma:        "364936b2739f5b5fdb75061019672e93aec2df788f65a1bba490d3a048d67b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951a7fa8b249e5542b63d82a77a0d0f0a299ca12bb3771ee0346889ebad55083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630bfb1a16c4a47096e8e424abf666c96610d3f8fd86c609de1494d19695811a"
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