class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.30.5.tar.gz"
  sha256 "c232f0abeeb7d335c7f80d2c0ea40d7e681bd27079f3669ded0bd1b6c28501ba"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f3257390cf995c790ed89c69cc444a48e4d7accbd01f23e65345809fcbc3a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca4cb86bbbb750837ce6f8457d8827915afbfed84a959a7d4063eab0b4e079b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc9089d027a398d1589263e8d5c4fc5f663e9ef1d4958b8ede597920e7415c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6fa79e409568647d1ec5c7ba7c63d617257a7a982aa3591387cef7cc490649"
    sha256 cellar: :any_skip_relocation, ventura:       "852119dcf0afc04b77ebdcfe460f6263f95448eb9915c8e478a605eaed0a9384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d5259c1f29ff02ea16ea7769189ece4f3e950f356e358eeba39cdba8548f052"
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