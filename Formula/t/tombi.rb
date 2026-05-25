class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0b82faeec04aa197baafd8924ecc78587684e12e53e70944f93a4c2f31c779e9"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87690aa8a861e8a5666257ffaa853538b068a948da7c2fd02ff38a6718c7482c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4145ebcb32b94daac55a9cb1a0e160e237561a1bc82b4af7020984544bd42dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20ce3d6f0a2aa3c36f8cd30ecc190043239aac11a18b40a46bee44cdefe1e76e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed1014a7f81ddcdec2607992ecdaf92e7209ae7b2969b397f82db4e30fabe5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab18c7a36e842ff3b2735a8fd46de2cb4d41928ac1f01e621efa67f5d51a24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc155ab047e4d2b9c2d089e70cebc7044cb528ea07985c2f37f151abd47cf81"
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