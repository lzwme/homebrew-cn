class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.40.tar.gz"
  sha256 "cd3e0b3cc0118e8faf0e86f644c56bbfc228fcd0a17dd0c0c96a235c3acff0cd"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df87c26c1069eaeee59795dff440de3e86ee690700b6bf4e29a44007ad8835af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d7ece5f397f03e9f081a2ff147e88d40d1e78723f9ab019c266043451c13afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a955ee58b1fcd2dfe2e0e811c05f27b4a0edab16b9559565922bf4bc9a2c0dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdb19611e2de692d321da5ad73292108da0127c56378d324a1287795725d9e4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9453ab5b5c451459b9b128b44b10136db778ab2d77b6f71fc5f30935da1bd31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d86eeb03a13c6c87520208eb343fb84665eb9523019400268b25324705cb8d"
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