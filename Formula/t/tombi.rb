class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "11d69d431c2503166f316527a16636f7fee0d4a252fac20b0b8eb201b63d07bf"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "935c76beec069ce4959a7aee5d492f6077a24a28924ed2fa59d945fcde027ea1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29ab75c381003049b5806f8ed68ad254547c5d87eda3e7fcc53f8712a9275166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70a42f9f070fb5deff6a270b8469cbab2588568c67124b2741f12e51dedbb1a5"
    sha256 cellar: :any,                 arm64_linux:       "baaab7c380be7ff9ffd97e49528aabd63905f3d7967bf5bd36618371421aaefa"
    sha256 cellar: :any,                 x86_64_linux:      "5e3a581bc9e74efdc6fa5951ac74151811e1dd6ff6e86c1c5d5739fe013c76f1"
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