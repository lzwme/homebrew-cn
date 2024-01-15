class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.5.tar.gz"
  sha256 "59aaf5ab08f2f2918bf9893cf9d2861ff922f06b4b28c56b5df408cb8890477f"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2d47cc495b2e684ca53785c88e96cdaf2ea38f3d598d2cc3ad413f1d13c01c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e31c4709df36bcdf9082a4bcb780cbe3a3b7f2da1b9c8168e2e353ae1bfe214"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "996943d7c66053c7466a56b4b10d1cbce2477f9918c5c83a7319b771da304404"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e394467ffaf31683280bbbea93bbcfb0fddc6291cb87e65c53876f7a9b6c479"
    sha256 cellar: :any_skip_relocation, ventura:        "13d65e4a614c03164726584b192f4884f56219ce4bfd04b10d24a6024c972e30"
    sha256 cellar: :any_skip_relocation, monterey:       "443f59cc2a937c4e78624eedfd0688f371e10c0eaf6589a44dc83b997afa1f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346f39f833e7fe3ca9751fbd67e68fb20991d28067b8c50fb6f17b8d28281e7e"
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