class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "321a7bd1c54947a6e50c5d10953edec660255cfc3901c6a6fd97769f3fbd3ce1"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44857c25ce9e0726f4996b6f6445560ed65ad09dc4eb91439c955a8e83e71848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1366fc78f46ef403e227d07af1893bc3993bd1b9f120f2dc680f88546b75ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13744220b94254adbcc46e2eedde43bdac131a36913ba7fac1fc19eb23578c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a92ef514012320283827769d2e7cb8f221b8d18dc48d7605ea1ec0ab7055a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12d1bf0ed359b420a187cb61fcaa9584a019ae8192bb9174202417865a3f5765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05d8043edfc0400a4d5815e23bc9d1a84bf3271a0a74860903c4cfb7bd85bd2e"
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