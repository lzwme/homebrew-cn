class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.5.tar.gz"
  sha256 "2c59bd1410b88840de94ab480cccc3b2af03634fa22d6cb0820103d2d968308f"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "847c0d0ec87abf3cf20f7091e1cc943dbddee43bfb52f48449390146e1a63322"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4886b2f5f4a714b48b38021cfa587276fd7d5d132b82563f4f44171cb6b0cfec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1a6d7902ed3e22bb4d9c6d3a36c812a6e6219881eac80b74d09c7f92883812"
    sha256 cellar: :any_skip_relocation, sonoma:         "27cb89cf42b08ffda4be1757fc5ad4d4719f79146a65f8f55fe0ae381f6bb1ab"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb9a2b4ed3e578ae075cd48b0653d1624368805a9065cec388b669e675407e4"
    sha256 cellar: :any_skip_relocation, monterey:       "907134708388a2148c0483fb9ec88c24f8a06702d3f1e3c4ac6f53fc545d7fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b5587cbfc7efd7e684d7c43599c6d8ff197831bbbcbd187fbe3f20721e9e2a"
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