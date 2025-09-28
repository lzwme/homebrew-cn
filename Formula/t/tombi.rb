class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.17.tar.gz"
  sha256 "a179eb134554b526b007f623e9e45161ef2152ffc0c834b93655a8354f30aae5"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ca97d316344a9da9abb96c1b48d63a3afe270db8ce432d82c2c65264293f5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ed086b9ce2a3a7560db4199335dce4ba188cdc3158d33b59d129dbde0e774e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac0f82df91c35834fc4973b5ee2c36238fff49bfd3a8a0de4f0796598f0d963"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5100cb97da11834f84943bb16979580cb07c2623efffd7f5def1e708db7e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f14ae305f924f49bc8ce72c83c3cdc48188f2027aa086410bbaaa6325641af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5718e5f553348c6ef7cccd6d034049c7174eb26d09fc13e73c909009545cf42"
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