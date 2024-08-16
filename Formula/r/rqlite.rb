class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.28.3.tar.gz"
  sha256 "19033d65458c15489d06a15b969aea5c78a2a6e320e2a6f5a015e72ac5bfa418"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb7af1bfbba7b12995cdfcf0bb02574df17d26cb478f0d819884fb6891c2029"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2427edbcbd0be496a39c4248311f3a7cd40171190498b7afc8c8b9e3348e35d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c2cf3fd5cbb4fc931257ba2e280ddfa1524d6752444abb377a0c7c8d50df4e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "88645805aa485cc1a7f8774ac9858b284ceae635f044b34079064bdd9f6b8e43"
    sha256 cellar: :any_skip_relocation, ventura:        "61d593a961faeb2c4f0a69e186e191eaf12376abc11dd9f74d0f232122d10cb3"
    sha256 cellar: :any_skip_relocation, monterey:       "679c416c402b5aa216180c950bb7506b05d1f49d1a9d1ee61224f7d4938ed0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4204a87f9680946cb3a8ace29c9f952a2212f720f9ab8180f28309db7c98b12d"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bincmd, ".cmd#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end