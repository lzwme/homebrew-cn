class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.32.7.tar.gz"
  sha256 "742edec534b75cf1d1941baa86819b0b3f276d716e4fa4012adef322602b2246"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f034fbeba00463a51af239b95c877135b44510724db05de86234f5759741a451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6e6d8faa5f30e913cc037e59110d029bb4e33a9ee39d852daf29ac5a90763e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bea792bf4d4d15b5282691a30345a579dbd7bf0445974fad0eed9358fb976ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b54f55c4302935da389e6bcf1f39a0b1a14bcee544de83c3c57332cbbc84b5"
    sha256 cellar: :any_skip_relocation, ventura:       "0d97c395afa5016d07b14d375b2990271a67e4dba64e47cdaead5b7fe6c30706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de377d22e903d8e88367d68ef42af268905797b1976ba5ef44e24dbd80332c0"
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