class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "4eafc737b8ccf5fe48549a27f3da4e09694a736562c7bd571069256d9c215b04"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10e257f82ca24baa3b218e6bccdba1b6955c32f879d0c37f991dc51459ad24d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b23bc7021d94c0e81e7e64de97c50e33690f799df46df7dcd0f9b78815ef5efb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "535d7aa35f5b07b34156f7ebf0f57b179f400cda2ed393b70b2a6f80de83ae12"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8fe4ed6153c4fe384e0ada5e53b29e80ef21a713c09519afe002a49097a2df"
    sha256 cellar: :any,                 arm64_linux:   "560eced8d490813323df02c74f9b8de6c692e70821dcbbac41e7db78e15d6aa3"
    sha256 cellar: :any,                 x86_64_linux:  "c90a6fb766ed50edd7204064deec7352447a52b7707a6d36912f522235a16488"
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