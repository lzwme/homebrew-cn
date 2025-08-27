class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.24.tar.gz"
  sha256 "01bfe347daa3784bc507e57b0f7fb57bcacb7f695e38aa9b320eb6810e7d3b14"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f415b8f6c908e54110dd3b21b8b4af8f2a6f59d1b18f0dd5521cffb7ec64181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab30423de9522a1cf3de1ab0b73d12370318d31272b1cfeccef02d36225cc75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf34295b046f565b998c6e40908dcaa4b9686abc1418b001bec4d8467ca3dcae"
    sha256 cellar: :any_skip_relocation, sonoma:        "87666accffd4b832b321774cc2d7209550dada36540c054e6bee37ae5ed6542c"
    sha256 cellar: :any_skip_relocation, ventura:       "4d5a3345be31e4c1daca2ed38fa6f40bae1980f3da287146cd4c1e9c71b207ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7f5da52ab4d7838e9f92262c85e301927085ad3551d1d3c9fb5ce8a251c05a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310aef73251f840c4332f60f66f430c11f37e515b0fb8151ec4eb31dd6ad1bf0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
  end

  test do
    system bin/"tinymist", "probe"

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

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = IO.popen([bin/"tinymist", "lsp"], "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end