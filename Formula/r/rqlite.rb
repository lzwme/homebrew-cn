class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.31.1.tar.gz"
  sha256 "ed33d976e717846b240d95f32122b3261063b00a575035fdfb903f7d89098bf9"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87bc6bdc5dec2258767ab179c1162d65916b14e6289e55df0cc236a779c18836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a8ab95d0b1edb5e3a460eee7a4512d127c9ccfb66ca8e64bb22ceb9d02f8b36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50f035a15aa02bf23b37c7c09e3212168fed55d58afa76e2e5ec8d1ac80b7d38"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a1d4bee3d75027c371f11119af76bcb67f6322571fa3f35383c79071ed125c0"
    sha256 cellar: :any_skip_relocation, ventura:       "39bccd30e9dccb4b42b700e3c420af537b8ea636c9fe1af494abe2f9e7e11b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95168c70d41d8307f393ae409f7baecdc039150d2f22396466409414cbcade01"
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