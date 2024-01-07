class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.0.tar.gz"
  sha256 "5fd6149914720c61acbb2f0429315c254ea19d973d561ef6a2ac2445d6915eb1"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b22559fbc5f7f1520065f8ef89e8c91b2a5f2917403f92fe9283180b917abccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "249fc509f919a3ce57ce6c04ca0b1d58ba1c647ea97255ccb9d9531358d465f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d78ce4d11d4afe290977b5f2d683c172f28f7eb83d025b8af09f205f588a5825"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd31ff6e2286be162375f2da20cec88af492ec2badbfd0c3ad226838f5eb1462"
    sha256 cellar: :any_skip_relocation, ventura:        "226fdd0df33296a3fc8c1f5627593f02cf432a77b6042b74ae1bc0b00d25315b"
    sha256 cellar: :any_skip_relocation, monterey:       "885336bb62a635ae083dd377ad3386f696af7bca8a99e838addf020347ca484a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14587ac39d2f17eea42ddf4d290a2fb2dd5de2e1924fda30c6c4a50355c0c1e6"
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