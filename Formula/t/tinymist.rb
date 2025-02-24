class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.13.0.tar.gz"
  sha256 "19b880c12885ad4923238d5af261bd6f0e52f1851ce6fb3d5ee91ed473f8fd97"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3098445993396bd95c899405d7b7e32b9544becc69e56fd04a63dd381d0928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894a857ab28fb6b62f979c32c48c04c6cfa2e1bcc72bdc6b159fc5a5d8fca7f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "518ef0a120815146809a1980bcbd59da67816114d24127d0b980433e993b209f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fef07c3b501dccb67500bb420ffbad3ba1334800ed8e67c0420f53ef4daa408"
    sha256 cellar: :any_skip_relocation, ventura:       "52ecf3d05159c7f381e2b1b1c7e31d6e0b8d08bb90dd8c47835dba3672eb3a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ad21ab21b35be75bb625386b2c4c320d67e7bc752933998dc950603a8052f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestinymist")
  end

  test do
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
    output = IO.popen(bin"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(^Content-Length: \d+i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end