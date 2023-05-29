class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://ghproxy.com/https://github.com/golang-migrate/migrate/archive/v4.16.0.tar.gz"
  sha256 "b5e7fad075a03b4017a4f620d711fc7c061b95fe68ac24e2ce795cd2158fc54a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc855d0af223192ea40bcaede934aeb6eac0ce1bb367ff1095799ded0b884f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553c5607b50d026500dcaa45b5cfcc428bc3eaf511225e238d350e485ce4a535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7b89e2378bbab1ef1de0d2fe367c4254c4c0d6660d33f7401440c8160fe0f1e"
    sha256 cellar: :any_skip_relocation, ventura:        "7ed8f29334a407a89cb87e5996d0bf768c60d72500a506a44d647335ba31ff58"
    sha256 cellar: :any_skip_relocation, monterey:       "a6acd301416b2384ee48f32403e738bac668afacdf86ff4db50bfbd2f1f6a7bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7385183ed9f7b5798eb1819bf120034aec1b34ed972d5b14926e8df054dd8504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00126493e2eccb31dd1c1f2cac61000d44f9b80f47ca69415bec2e676dc2396b"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end