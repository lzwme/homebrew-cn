class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.32.6.tar.gz"
  sha256 "cb0bcdcb69b85159c6892b6203dde60993b875a9394727a9cd55a7bac9a75932"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be56fb648044a2789e38ac369a7e022a6564e30fc19f38264fbfa2be16ddf45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf2e59382fd6f7f93f08662bb84dbad04058edd15893c73f106a53781e3acca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "821cbb2ef82e74b0b5dfd8738a1656c048c5b5f1ff5c8b4f0812bba022927a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "32af078225bf473642e49de04226b8b948694524a5fa42c1e27e41139a8c65bf"
    sha256 cellar: :any_skip_relocation, ventura:       "2311f22cd72e461dd6c8413fb722d851f27c7637488fbf8d4cae7be5c06ded8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3e851ad0ef95d188a911b49832dc5a0b4c8ef4c33dd7bc84250d3c0ab8d9d45"
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