class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "e35819187cffb082611494fa4f0283be59e0e35297891abf2fe5451ef667f661"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c536a48eb07b64e8e1ea564d1731df8ce0c4f32c09efc5fd266bbaa40bbbc46e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bae6cfab62036d1f5a68e03d58347cbc5b95b01599f086206b0edf9fe6f27ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768aeba76635780c6af63da751302df4c4bb666a7a63959d4138029f8368edec"
    sha256 cellar: :any_skip_relocation, sonoma:        "84b8a871b2601f68e4587e62857b350c81956694210888cce533decdb7df33ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e54d65fb53755f5583f192f93ad871921746e81d24002778ecb76598384af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1aaaaef952f82d58df877a06612d551d0a258982b74bc2af472aae0c81ebd5"
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