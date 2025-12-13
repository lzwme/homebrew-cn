class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "fea32038db8bca1f4833d4040dff7fb5f35e8991efcd02f6a85d9769953ea281"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d60b8040a7a31ec4541ca3d8b0a538f65c81dc6a99315942c6eb59208427cb4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "589bc330a51e863c2b7053ee6d17ddf040f8da322a5d9464ac463d4f6734519a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4108c83260392440594e4ff1583bdf2f557af36b0b8b9f84b6d714156da83e2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d5d723bb99de9884f813446bd318ca2d34498f82abc827ff9fe0c16dec79114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c291b4a69ae359d82dde13ab1b35eba1e26bbc84f328c54a0b96fbb79653998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f394bde8e874ed2aad5dd8ed62ba3a856ab30d271bd3c3299b02f1a16f6149a"
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