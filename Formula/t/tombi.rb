class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "f98073e12be2203807d44aa66c1fb935098c3d49c185f448d2c4588ec98b686b"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24ff4384a2ec1c1987ae165a8d150f8205c167b6c8a92095285996db5838b0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e4f87869b551d723131458b54dd1e1cf1c372cdf26190fb31534aa23552d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f505fe8b16fa80ee5ce984ce432a2a7ff93b0506603cf74b9d439e3363a3afaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd7defcf889510af77b28853b69fbf412e3ba1ebcad39407b7afab2eb6560090"
    sha256 cellar: :any,                 arm64_linux:   "ca0cd638cd277a41424c30b0ce1a790268081faab9949520ed3e851d4fbe82ba"
    sha256 cellar: :any,                 x86_64_linux:  "c7970d9f180a9ec9b11089acbe8474c0fed1ddc4100d8644914340f7e8c9f41f"
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