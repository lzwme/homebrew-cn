class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.32.4.tar.gz"
  sha256 "7c8f516003033b569786853529b9d23134e53843d2eed0189a775b220d538db4"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61129377aadf65c20f6ffc8e76eb3cc7994a7beb7289aaed7a5cc7d80981e9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c01302152e2b16cd664aff3ef89626b28b07ba7e5ba4eb7066eb3dde2221efbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8efc7168a96793b946e0b7c5c292094a6eeefea4067eba944b0ddf55d60503be"
    sha256 cellar: :any_skip_relocation, sonoma:        "7413b9c99b6b0576603df25b7b91435e7c715c21d5f832afbe1deb4d894989af"
    sha256 cellar: :any_skip_relocation, ventura:       "8e9b0a42d35b48b3b52740ed53d850e48082ceaca444d873985b15c94559dcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c39abfdc2678a55d12f778884a6dd3eb8f1a52867cc1b02987fd663d7dec27d0"
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