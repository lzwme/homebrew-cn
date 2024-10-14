class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.32.1.tar.gz"
  sha256 "b56cbb2f5a1be6f498f1b5423ce04ac63e674e8098af1d7e464a28e22b24e425"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa53d12adc138fef6b29310d5567eb2d601d692ca26ee2a9ed5ef371ac3d765d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f24c0813ef0ff630b9f299904117e042e064fdb036ea199fdbbca406e058cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bb414eae91daf2a41b67ab4be67ba472a834bb2f8fcf268a6027a3910af1bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4381baf643f8c6a25b77edf81240ca2c9b7f9b19c150861c606ec8fcd1054e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "948d0c9e57bae37507613ce607a05774ec85412b86847a1e819a2f278bc70624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e3458892581fd9adc5defca91b7e6fd62bbb4a6ce2d252ea86d1f8c975e67c2"
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