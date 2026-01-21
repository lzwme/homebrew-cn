class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "47343e1f56d0ecf01c3f003ce69c7d58243efe58c80b45e597868d6350d5110f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748badede6d653ed1a5c61c5ddcd43ce51f876e6dac22116930ffd6d6870f5a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e930dcd40b9c812fa54896c4893a42f7ccb100a2aabb2fbb163547d52331d348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c87390ee2c8477582b31d76069edc945476937376a8349357950ac226d9225"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d37fd075e6f682476dd144dfeb73f5505d078ae75b194c57c5c3e51432c443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e82c7d4af44039dac2886fbadd23ade62f3ed7921b0e279325d67b19cf12dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c94d3e4f15a32ae934ce3c99b85c6e84c4acef1181149a0ff5f3b1d77ab58c0"
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