class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "bfcfa24ef1d785d2e579b7a342ecfdaf8a6a4e6160b13d93778c409c6590a247"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84b6431b9d5e6266ffa455b2f8b62c963907889342d254ba1132353d352c2c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2e3e47b431482749f36e822adf39fb04b4d5f9525051dceb1564bf40ac132a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c16add7909c1db9faf75ff78cb57a35e617aa9a12860155553d7bf50d14310"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f596b9d35b046731c1b6925ac716f3841de45ba7675bdb24ebfc96690f5b58b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abc6d40c4652f3734f864ad0c68e0a04f5d83e6fa8b237bd8b0e35a4d7b39d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ae8c722605a16a3dd7290bbb3bfaa7d95f9ecc64748a750201204c8dcd701d"
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