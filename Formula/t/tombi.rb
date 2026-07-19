class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "84a0a7e2a1501a665602cf60702cc43dc03b5759073a8fbcaf3e8eb1451664c9"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ed1ba1926ffeabb5c89b0638ff083d73d70a17c936480698cd12cfc8ff6f322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "038fcaef7734ac51170178f608fa5d817a6272b322c9a204009b1ad97a0b3683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c3bfb415d3bd183a53c4edd5900c9b1f37948fa2a4351661de539d0ef00dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "614888e67db4261fcb24567e8bfa7573fddd92828ec7d4399456ab68c8e04fb6"
    sha256 cellar: :any,                 arm64_linux:   "10f5524990896ed3dc6d90077964323570675b1bd1594537542cb8ba5208be4f"
    sha256 cellar: :any,                 x86_64_linux:  "007efbcb359335d4dc7f6c1efeee710b7087e4bcebc49483b73cfcc5e661e613"
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