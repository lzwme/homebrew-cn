class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "fcd67c82739fcb5a42d9c8fffbb873ef0ad1addcc03415baf24b9629fc9a3534"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1c2c4e7c39c947946a4e14fd3416d061806ee67d05b949cbe19aa0ba0c3b028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc22757f0e20c2118bc8dc258a116b213373742db6a4b77630ec6a8f91a39a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b66e14b7388d8b7f6146803585a3753aa68860ec12476f6b776155c263e71d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "dad7dd173ae7e52659d01b14a8bba7252204e59c60475e00fe787f5f9c27ef1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "862aaae42dde1d6e39783483680513b4633ab5f41e69d710a05240c02bde2a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb757cd1b0bf57bf2a8ac5c32b79d3e7ab1776cb97cd4e23e4f40d023de0ade"
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