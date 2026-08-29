class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "1166ee52d1a2bc8f442524fc0ba11ec0e99bb9f11a1539654b1f9453799721f2"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f04efa6c6c35864c4d48be5451db8466959fb148b607708e53a7e368aa201500"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e198477c339c3057ce60a1eb511308c1fa96a6457a83c45129163a84f1be80ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b981c2cae75637a3a73aaa42b59dd1b39ce00a6b230e7065533f1e57c7de7ecd"
    sha256 cellar: :any,                 arm64_linux:   "bcc5b8422a1c6046b8a01913e93f5268c4bde8d1e82d42047186449a04dcb669"
    sha256 cellar: :any,                 x86_64_linux:  "28450e9eb9a1686f47043c6d1b32a352b817c340aad5c0b33963ab257f1563a7"
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