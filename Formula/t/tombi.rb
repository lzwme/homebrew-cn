class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "9b77e4bb82b337c5809cfc3b77f1d75949c7ed0d1650bd645714b9dd3ca45fb3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "176394f33d4616ef9888aec9739da320c709707cc16fd7ee7a5533e916cca1e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6817696fa10368128d5c227939b1e50a3d462b9dc296bf01eb19a2b3ccd88a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "295972ec1e91d516d6303a01ac83bc418d5d89114f9936de2e48dc4aa00eef63"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c09a7527c5f9ff1cfeb7266a6925e3a3fb12595d817a4b9fceafbbc8ee16b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc367859cc4c7588e16783439e2b553d6319b85f7dc44a28d20ddf6ba543ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89f3bdebd7cd4a04462fad82cbc34258c7d3fa4229a82d5970d3fc8fb57234d"
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