class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "7fdc1d2a200df7ea2487c8ee2eab140134c7a71e1c2262473c5609fdd03266ef"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9858e47bcaf9197f18f231b33bb687878a9767bec11aa52439a18723b1df24c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68589e6b693f0a85927c21ac0db5aadcd34a920e3878aaae25a2788e83a1dece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa9ce5cc981d6eb31f7e59a376ae15367ce2cb4cf84549029e13fdee8fb5db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67a34623a43fcc6e9490bf8bece6818574a9becdbc11fe9e9094d604647ef8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3c38a2a66e8fb5008648d76f5ceb3ae61818270cd1efbacf3fa179c7693f1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0372250c6a7a5d0fd1009e4ca479e9384eae0d88ac38321851bc057889c2f88d"
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