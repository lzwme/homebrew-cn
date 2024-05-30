class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.24.8.tar.gz"
  sha256 "82ccf3df36cb0791897a204abe823f0a32d76c3567d09c7c726f8e9ee040a9e1"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b88eb2af77a41761b8966f71282ac1ae064cd0a77198a96ad5eae3388b9fee54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80dfa48fb7572a6d1bcf0cd39aa92d413fd06df9baf1185cce7b3accfe3ec9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7f7d7c62db855a5558db4bea85d910376733ede4268d9b73780cba0f59fea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e762379101d49940f6202ca90ca564165eec7fafbd8023ba504650dc8eab3984"
    sha256 cellar: :any_skip_relocation, ventura:        "19010ebfcb6ab660d90fd7a93b4ab89a753583c1b004d491bb4f98907e2c60f5"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcf2f63eb0e1b72edbda49012d9ec7d186ca16e55f6f65956a2bf17d2ff323e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe43e4a4fd75fd7ab4c4220f15642d0486f317bb583355151e10fee7118e73d9"
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