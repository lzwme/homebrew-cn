class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "a8bce17216ecc648216afea676fb00c3af500dbf51343ea79430bab41a64e584"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8c88eefab4778b185f9b6f76bec097c797a833621ad7c53efd7d490ca686eb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f083e6868a60d766ed186ec92d32543ae5f75978ae4cee0f8ea502443dda3f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e52bbf392bc67893773b0ffdcd8190e97638d78e96374a9243cee098572a422"
    sha256 cellar: :any,                 arm64_linux:       "71f37a458606184d866021230a1ed4eb8adca411db7f41ec38b6335a199ca724"
    sha256 cellar: :any,                 x86_64_linux:      "a32b3267de35ed9caf6f4bc3a880a99c5d167131593fd34161856b9d9cacfc97"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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