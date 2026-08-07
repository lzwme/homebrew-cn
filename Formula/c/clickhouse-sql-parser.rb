class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://ghfast.top/https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "cdb1f7b22a488043a0a5698058b84a40a9819ade9ce5e0bf873f33aa045e43fc"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b4d4a497d894d7a63ecc101b03106748880d4f88e94d2264dc779073b8dc92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1b4d4a497d894d7a63ecc101b03106748880d4f88e94d2264dc779073b8dc92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b4d4a497d894d7a63ecc101b03106748880d4f88e94d2264dc779073b8dc92"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa8950d8422838fe4d8a8254e5ee20bcc4de2d87a1c329c94a265b4519bc38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64f3a16b528f5400761ff646318f9eac552c009a5779a1ba9b3e6c84c35129a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c36f16e470082c739a4a787a1e31ce5e95c056735054a3225b0b1f35c9c36bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end