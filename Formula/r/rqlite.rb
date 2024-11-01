class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.32.5.tar.gz"
  sha256 "e56f8e479a12256ea65bfc440c9840587933fcc856ff3aaef4446fe165daedc8"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "703f8fa4532bdaf36d84397d1fed7009fb05df192a84dcbca6f06f6d180d0638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4756b811ad38f7e319433e515f3ac7fd39b251d8ad83ff35c831002b0211a87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71720a4cc054972116b084a89d552c3758f8832750f275bd22d310bcfdd9d3df"
    sha256 cellar: :any_skip_relocation, sonoma:        "973435a5f400310c6583622880e9bea986b99e6a1c707edb31ca96dc04ae5b97"
    sha256 cellar: :any_skip_relocation, ventura:       "a2e28ab186ae9b8a21c7802d29cc7b905bb40f82bc0da131cfd53ce43e18b7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832cb5ea64cf3ad0accccf73d1a8dfa82f5209adb55e69c687a7ffeb7ec50786"
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