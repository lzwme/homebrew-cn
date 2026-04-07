class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.15.tar.gz"
  sha256 "e2c2fe90d26a5a5b68cbf7d99b071f54fc889cb1c6414af5bfd5d74b06734c73"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa01b402af3da98f7a2e1e7a8e2f4c6c24ad43931830278986fe036ffe3dc021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "115cf1ad66e0fda4eb94bde841f59682df4e8ab1c54b5a239418ee660a7fc129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "994d8b8700177a40436885d0faffc8c89c0e9a9ab98d9a28c2d6147539cb9c27"
    sha256 cellar: :any_skip_relocation, sonoma:        "1634166f1f029e638637a265bc212a194709adaea734b0ed7817e91a9e150f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7914777b397e4fcbea169466cfc7565d79a392e397c94225ac1d07346a31cd3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e11352dde2e83fa304413e0fb3e0b40ffefe5653726671b41b8b5ba4e62e1f"
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