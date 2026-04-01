class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.13.tar.gz"
  sha256 "f51afd70e773a91d29e85f456b746af7d85599ae5d97d944d31361ba1b797499"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "346507a333585aa96d5a3504e5a085a5e0981d8b20ea7f0e6d2de0e4c753ad34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35758a0e24558c009c5bd6669487dfabc3fc00bd34bd2fa44650b41d40762b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c3b3f25a7bf09c43a9c579910c4af05b1e67043496ea1092796dd0ee1800bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0f0c913f92239283de3cf4574c6407e3e0c184169c09cd2eb1650cfe096ddfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a87b5e4a3e9f6687c32db857a9dc35ce192d5ede5099184fdd56b609cec86ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0866f867b682053b8f0b8777ccaeca0d9b5b68d1e86c67f1800a74bfb181682"
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