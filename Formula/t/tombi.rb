class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "223bbdbd3c086862315195fbfafe10f6a00afd2c4b19ded0cff7a5a1fecb3e6e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ec3d3c82fda20fb07c80f0aac6ea8b2c520ef3a21bf090af428d27f079aa0cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b84597eccf849229038605ed371dbb583ffad81afa3ee92facc7c8fa9a8387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a1d2883d0ef9975de8c976910735a02862e98ba5d689ae9fe8635e93be8919"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fc391b8ceae1bb96113ae523b33a308dac69b6c8f0b1e95359d2c218d3c1c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c93570c6605daf5c7c917a11586cc3e9c7578b5912eb80ca5742dd24c666bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5173ce979ff4563c14edf094155685694c678d43e3444a981084f4ae471235bc"
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