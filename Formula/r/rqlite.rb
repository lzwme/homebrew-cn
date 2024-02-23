class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.21.1.tar.gz"
  sha256 "adbfaf610e0e8110a259220e6c2fbe5e013e27e788e3f906471312ab488c05b6"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b8f1746b118313a472e748ff71bdba1bec8684ca988c030f45b2f6fe78bca21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e787c9a9ce5038409a373760269ea71f8ca3a4ecb8b03aee9fe8501c4ddd83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621e3be857f740b44024b99afd66325b7dc4e53afb358afa14a9658ae9e62f05"
    sha256 cellar: :any_skip_relocation, sonoma:         "f81658e303a44acb676e96bcb9c357cc3c4e48dfaa773b121e70974b2e76433e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e0fac54b6530fc8ca960f0b6240f1fda71ce39fdd16c5276b0c5632054f3df"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2b025fb4b9167c572914c45fbc36b46580bb36da347753fc994082017a1488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3699e8c24fef1f2261a687bfb57307fa2c8c2a3965f0afac167dbcb7494724d"
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