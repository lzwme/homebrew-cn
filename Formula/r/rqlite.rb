class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.4.tar.gz"
  sha256 "f2bb28af49ff3700c119e60291fc29513d375735b8a37321137706dd95c267d2"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6432a9eaed6c25d1b3ecd67465152eae7b541f47d99dc015ed0ab0051e93e369"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba15cc15b728f17b785aa9b9e43739b892b6b4ffd6afc7afed5bf566c8e1fe5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7933f5153e65e9a86f6308f1fd4eb8c18b88dc9a36d602025d141610f5704a7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "89a07d27febfef5efc4d1110d5436d0c5c58c2587264ea169b882344f50a3802"
    sha256 cellar: :any_skip_relocation, ventura:        "872c6dea624291253f74c604914283e32dfab71d2ce2e7fd3e4be2e2117b7d23"
    sha256 cellar: :any_skip_relocation, monterey:       "c54cc0173056480828a4f0c26d5a477fe6b37bb5f078f2163e5c4b5f7a5bacbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54dadcc06a83a94c8697e0db16fbe154e91ffa00b04240f4c0015d1a17f4e8bc"
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