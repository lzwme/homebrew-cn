class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.8.tar.gz"
  sha256 "33b1e01ce9bd167ede86bb1978d4a105a2fe6bba2b41f45d35e3a7d6b324266b"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33e07e719f4cd19b0567985d98198d46d4084623aa2e8cf7601dda944d8a6ed0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea4833bb18151600d69cd45d5e1a2c3bce02aaa9804bd4baccf4699b25f6f8fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5b2ad7f17f409ee2888d222739194d7dc756c2b6f78ccd3e22b0bbe11ab095"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f4711b6db383901568c91da1bebba01e20217f6918df61216f0dc6f9d480eb"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7470e0d1340d7b36a94133c70fe6ca9ed6ecec4b402eb6235a230cf87f3f35"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8cd80f06cca83af3f4f1cd6a67b095c9437933b1b289109ca3941ea6cc5181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76b37f6da44855748c3bcabf1eba79c546f5727f1dab702175d4ff830c39e65"
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