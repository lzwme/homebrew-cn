class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://ghfast.top/https://github.com/authzed/spicedb/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "23b1af438a187e232333591684a0da26dd4b687d07f8a1777c5e22d9567d4712"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a785a39e00e8a09cd69d697497d84b083907a3bd1192bb8868a616944c12a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d7c609a292208370cab753a4735dfc6af062c06fd1b8875e4a2fe2532b577b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14c137be894abeb9ed94e703db7976fdc0e86ab4782e29b4f62b127314c8f4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3862ae378dd82f7aadc88cf7e3bbc44f136fc511433d8ca06c40317af2ffa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7fb0e97e5baec5a6688559574300f15b3090e2323a28234ae9cdfb68276577b"
    sha256 cellar: :any,                 x86_64_linux:  "d9396e4dc0a9a20b9004645f7d0b503320502dd50ceb6dbb3d2755b3c00796b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/jzelinskie/cobrautil/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spicedb"

    generate_completions_from_executable(bin/"spicedb", shell_parameter_format: :cobra)
    (man1/"spicedb.1").write Utils.safe_popen_read(bin/"spicedb", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spicedb version")

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

    Open3.popen3(bin/"spicedb", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end