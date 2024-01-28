class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.1.tar.gz"
  sha256 "31bbfd51c0983dd7d95b82d4bad9c8ec9ca576027be13fcb3a87674e79ce1749"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4046828f78a079cbf0bb93b5842a7136657046691b1907f2031197607dac490c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c746edbbaa73584fd33c1a6637f5d82bff006d5a902175913d539b1bcd3c1d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a39290418843153d9543a02588d392c4022bbc45e453063e69124bd08c3b1f26"
    sha256 cellar: :any_skip_relocation, sonoma:         "45b6bd4ada8d0c1f8b7299f84419ffe59c6f6e4dff16065fa022aa5aafab2c11"
    sha256 cellar: :any_skip_relocation, ventura:        "2355de19dcf9946d0a7e6cd14a20646f385f7cdb093457fbfd2a5b3e7b6d6299"
    sha256 cellar: :any_skip_relocation, monterey:       "4c4f59bf4e96a6f9c6d963d3a71b5380373419d708049e4664a9a1a528ebde12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2966b3eac34862789111b7c67e00418b8138fce9a6d4f8b604e4efaa2ee820"
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