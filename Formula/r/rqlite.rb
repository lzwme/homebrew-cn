class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.11.1.tar.gz"
  sha256 "9f4303127525907d99ecb3e9ec772b7ff2e61ec079620b0e9c6ef928062d0993"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "480c00df071ae077d892e7e7babcfe65a166c8f427f9ede694b79f4e7cb5423f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9643498ec1d5c72456ce46cd2098dba955675e28676ce10826bb02c9e6b01308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbcf6787007ce280bfeca4ffbe21bd51069cc63a648b88565e4ca690198267d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3f324a1aa417a034f0b7126aeaf30775d25c0b5420aae96f09e4a74bc53b3fc"
    sha256 cellar: :any_skip_relocation, ventura:        "e1284e95d5541f49e113e5e4377000a46307636dae1a2cb96b3d1eeae524fa08"
    sha256 cellar: :any_skip_relocation, monterey:       "2497a5ef328a50225dd5728199c65faee77388d58c0ab899dc8e30f62eaf49ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75dd54b1654419b3d713653a90f8f1868ceea3592bca36135929d97ea7dcda3"
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