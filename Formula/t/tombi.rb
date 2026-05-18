class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "cd4807db484212bce17db8ff0cf617f11be1c71a0d60b49d684f51b28fa53716"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aa9c9a667394ebb3023447bbfe7c140596201699b89205b1694067a7067cf7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce0f354b1d7cc848aaa10dd4c555ce991fe58f4a3be8e43f25258bc1f9598cec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06879375d2a8451416cbca828bfabf6b8c8e55966ddce1b5cd7ef5b12f5f004b"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a7720eb7e9c19d54d006f22c7a0008adfae1c41fa6af6f9d14aed801b82bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de258dccd331a9fab685554f77d50da92e49e56d9c5dd220c0cf5ec40fea8fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce20f20623fc6b0042a802c42cc2ba5502475b34ce1a413181222b62e2ea6ec"
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