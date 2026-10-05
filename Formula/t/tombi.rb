class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "90987ac852bc2d0c99eb839f3181450e83c00817897f859ca17ef9c2cd47b32c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76f1efc1b6207618c8f2b60f5df2b199b3e6899bc59830314ace742f68cb504a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff0f3b03aed8c575bd9f8a164957de532753ea4a0e37907b9cf2bd8185a2ecc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2f26ba9eb095e087497f38b0a67899abbe2f024e53936501af0634dbd0630f9"
    sha256 cellar: :any,                 arm64_linux:       "292f7b668866c2a5733443d6b164b282dff90a5a6813e4a844e3a81e8cd78747"
    sha256 cellar: :any,                 x86_64_linux:      "2e902c00e2b9d16b7fc95aba51be46f4db651dc79d9a87db005e2de2786ef098"
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