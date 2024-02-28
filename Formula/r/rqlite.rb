class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.22.0.tar.gz"
  sha256 "406390a3cc6c9b8f5143ae55c9fe70ddff4461ea3f0973c2b9a3085297e7d0ed"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ffa7111b14a09f58258ec839a898e26db8782d6028392e154082c1595f4ca86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf3d3b98b0592ef08f7dffa61d4dad26a63ba2fd9648878ccad79d46a82d022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff5fd63923417988d72906132686f13ed7ed0e4957de6d6686670c0977081c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bed4ef9b895e33cdfff63cff5fd9a98d44582d60377dd0b088260b6c02897a15"
    sha256 cellar: :any_skip_relocation, ventura:        "abe5eb960b3e66b9778f09cba2e79f4c03dfda2398e2c64b4226b51bc43cf259"
    sha256 cellar: :any_skip_relocation, monterey:       "302102f37a95bbf48fc4eb69b7429b80e56c67431e5f98ffc9e0046ccc1be864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108046d5df12544c283faf5763df5a95816302bd15cee03a001ef64f5e8dd854"
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