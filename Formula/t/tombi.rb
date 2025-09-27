class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.16.tar.gz"
  sha256 "1c5e2535a8144697bded8497a5c528229212be2ec6ad5afb9d61c0e798b07078"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0f600ac3a4f8ec661ee3c4a807d554fde10ef1eaf031c73a7a83efbed33cd1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f73298a4c25e36a81b7cf7791e83bb54a6976e89db9938042570d04d6ecfd6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0e07c0631e306a6e2e767d1ff5ab68067f8fc8d17cd680e9400ba468f2c147"
    sha256 cellar: :any_skip_relocation, sonoma:        "294f1b20053c0cbad2f5b88b718921b1fdae847792b57b7e46f498e6dd309f2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dbcccca71544f5177d02c5a765d9fd447e873b11521325b684941375444a611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db5c03dbfe8a2326f28d7c534969193fd9a8ca105e4a08a3fbe327418e1a18b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
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