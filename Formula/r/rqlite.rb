class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.13.2.tar.gz"
  sha256 "5fb6aae8f5649c028d30337bd9c79fcd68c66f2dd2f333ff4167925d5582e63c"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c845b7addee1ad61422c373ac0105cb4092807fb98f14e2086d5f186a56d3b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9022d8b62343c8ffe5db83d4ca46b7ebd6dee6df0626cedb3ec51327728dad41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b3eaa925e7be3234d2220da3cf0c4cb07f26512993855df64d698b4951879cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ccf49ba834ad5f692aaf58a157e2589a5c3c942c624eca6fc18bbddf94a229c"
    sha256 cellar: :any_skip_relocation, ventura:        "feab64692683c9109a075bbb53f78b169974e19a47ef735a5c360874d9316332"
    sha256 cellar: :any_skip_relocation, monterey:       "80ac68052dcfef41bd6ac74fcd0ee3d14732cf23db09264cd23085822f75f05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4ecf1e8e6dca3434eb3a466d7aa82c3f4372edff5a44cbc02df8a06aece982"
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