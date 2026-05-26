class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c36a1aff7b3c7cd78ef1ffd7262517aa455314874ef15e825c6ad7ab238d1c2a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03405c8821a525406280f7a70fe428e35748e4638f949f6758cd0197d0f23c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2b6dfdc4b694f4f9c0d4b63707c6aa8f5516765534bce387ac6e9cef30c2ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "322a1be8c9d2f7c178dafe34fc6bf358dba3300c877015baf8a1785ad053eae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe6b6df242db6a7066d0368939b87147f56240b63a5fdb551b2fe1882a08501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe68c90eed57147f6e40feff4d27b5af13ab94fe20ca4214ae7b40b2640199e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2efec20f7ebf24af2ee5cf7e14cdf5b63083df7d53de3d1990e5fcdf303bec2d"
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