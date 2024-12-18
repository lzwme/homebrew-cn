class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.1.tar.gz"
  sha256 "aedb375980d67933472a22e208c6d972a665e3b9f6391327e609932772afa676"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedf3243026ee9dbe704f07ba04c189658e0d407ef08f2ccc10ff563536151dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be5a5f716379dbbe0fb07507594397931aacad20558957775fc1a95f1bc3e95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "993d7d3eae02c43ccbfd05534d66a51b96fa265c74068ca94d4b0805a4272c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba5481f69f5c6a1528c07edc984278200b933fb6c2a5c3a03eaf689137e66cc"
    sha256 cellar: :any_skip_relocation, ventura:       "6c38443b894560046971d392738f817ba3e222760ea2a5dfc994af52a1d2f7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a39e998309667e6dafb848b553d8dd27f331fe23ba5e2f95d8913c62bc28a2"
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

    (testpath"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end