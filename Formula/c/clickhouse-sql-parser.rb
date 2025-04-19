class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https:github.comAfterShipclickhouse-sql-parser"
  url "https:github.comAfterShipclickhouse-sql-parserarchiverefstagsv0.4.6.tar.gz"
  sha256 "95e03a93c4367de3fb65fc457081d295e55c0ef31329f707a0417d19a80f1d9a"
  license "MIT"
  head "https:github.comAfterShipclickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddbd2e2083fcbbd68c150754c537302b859c91918699a92b8a246b75bbc57fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddbd2e2083fcbbd68c150754c537302b859c91918699a92b8a246b75bbc57fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddbd2e2083fcbbd68c150754c537302b859c91918699a92b8a246b75bbc57fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d624c5f4ae30c2805a1e2e63b51e47dc3f0965e22a39299f099f37488df865c7"
    sha256 cellar: :any_skip_relocation, ventura:       "d624c5f4ae30c2805a1e2e63b51e47dc3f0965e22a39299f099f37488df865c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f15cf8706af3d6a92a7aecb9a638a192ba7c08700f6a80dd06c84babc8da88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e12932307e8a1a9225fcc8e3a08fcd4b97c04a21648129fe03d9449dc26eb9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end