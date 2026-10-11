class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e2bf0d66048af370c39d5b18ff9743c268aaf9bdad4a39f26e58d4c1809610b1"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ebadc4bebcd20568c553a522957ae75d60bb8bb9db8e95b88774955fd7aab57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2cbc04c9e3a63ec3488e57cb5c0a3b52de2024b0076337f00a61e628e3d2672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f77f29b3a8555ba312d3524713d1243054b9c396edce6f2cfd3396d2fe7266e"
    sha256 cellar: :any,                 arm64_linux:       "c75eca403951c814625c6dc41219ef0b879a6c3ee283aca3ea12989b023ad822"
    sha256 cellar: :any,                 x86_64_linux:      "6bff0775a7ce8b76c94b2242a966b4922d4d020408c0e4d9400fc9d01e5357ff"
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