class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.12.1.tar.gz"
  sha256 "dbb189eb7eef79587af8d93b53186d76df74add485eca7d9ea1e0ffd66207502"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5796bc6fe728a0176bea7053246ba192db32851d1655acd11b49fa8df2c9eff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daad947fbf923c86e48efeb0857c0118604048172b7aa31483d5ecebe89efb03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84596a87839d63c005b2e22e53f6f99ea6e23115b158821e1f84b96f7139ab53"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b035edd4fae27cf4cd79037e61ba9eead209d10f5a93db52ab229a7c27976b4"
    sha256 cellar: :any_skip_relocation, ventura:        "b1f06a7de71e031bf47e80f48c112b7548aa38096c8c6dca0ab74c2f064eca92"
    sha256 cellar: :any_skip_relocation, monterey:       "17ab1f6d4c62cfe8dce546acba5db8da99a6ab876793378a874d3f532ec2f853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a960e656e24455c9677aebf3b11011e168799e641bf6ac2f98f2660270ee69"
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