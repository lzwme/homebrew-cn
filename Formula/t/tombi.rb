class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "26663632d519f92826794e0d671ef9fad5ff3df9162a3ac7f884ed9f2784f8ba"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "606768abca74552733911a5ff57fe80a23c1139877d86a76422fe30f932d6ca2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19e6cfe36e1c8a92c798c82ee954b0ed815dd3c7db3e4c430b9134caf820f3fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b05e30920c53318eb37388db7b3713aae92b46fa8e7ca105bc8f07df7785a5bf"
    sha256 cellar: :any,                 arm64_linux:       "a0ee19ad3de010250e7580df342d6f67f76a6dccd759c603cb905220cd050f76"
    sha256 cellar: :any,                 x86_64_linux:      "47c11469ac8346fc646520e738732d20d1fa0df908dbf238a9d68ce0b1daf1d5"
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