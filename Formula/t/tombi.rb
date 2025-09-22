class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "adf467a6775d363cd92712c93ed1144c953e73ca1081aa8dcff0b8a8266ab8a3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51afa28e578c567031c05f16e160e7dde50232f395681bde6beb958d0cae3e0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91bbbce4904d165f8eaf37e448d6625315fbc764d89f6dacf2cb280c7468ef0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f56aa2104d2f72d4e46560c26e4b50dbef79ace9af34929054b68686f2fdac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bbee8dd002a3111e2d9429ce78a456331d143707fca74cfec842952dad1ed22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b8ca6337aaf749dbd9b2ca0e7b9639a9af5a87b23e69b1776ec5d7585dfd25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a8c23d9457ffb225b3fe77266156ad20744d509a16caec3ad5125fa4a6aeed"
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