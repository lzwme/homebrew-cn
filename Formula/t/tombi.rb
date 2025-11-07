class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.41.tar.gz"
  sha256 "062e5c0984ef5bbd2cd4814a3f47db5030442e43a61b0105fe8ad42c712c1096"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6405c60aaeeb2c2b758970912335c3bc1b26ccd34cc8f3bc1492908b72e5073f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcb0f2c7dfb302c7272c97fec7414bb33b14f93cdd37f0f9ef61e2e0e42aba2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfa5093f2664ab49f0cab4a002f0b744944f6346753cb51f4626077a55308056"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42216e305e1fc382b2015b46a4d2b59b8d7f12d628132771ae368d76e3f93b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b45c2b0291c9c59eecf64da0a90737ab3aed26cc332515115ae645c69a0ca00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ccfe959b4109f7cbe22a749782145344bbc79916451e05073c888efc1c8929f"
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