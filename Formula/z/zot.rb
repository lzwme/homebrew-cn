class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.87.tar.gz"
  sha256 "7e9f06d0e4d3bbc53075c85963384285aa71588b565982be9090768cca3ee847"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6341a83e71e57ad7e94c6a656643ed1a4286e02091ff9a5393092244360c15f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6341a83e71e57ad7e94c6a656643ed1a4286e02091ff9a5393092244360c15f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6341a83e71e57ad7e94c6a656643ed1a4286e02091ff9a5393092244360c15f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ecd26f34e3145c99edaad769852ffac212a572c2d9f2c2dea8234c4ab263fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178b8bd2ec6715a5d71db7a647a8f5ac1929089d481634cb182b1cf1a9075ea9"
    sha256 cellar: :any,                 x86_64_linux:  "ac12ac713fc388562ce875730abc0ed511c7113163e3f69d4f75423c79c43e60"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end