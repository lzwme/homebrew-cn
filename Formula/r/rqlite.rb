class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.13.tar.gz"
  sha256 "0171f44de0cd19c5cd8c0048ef0a9f8405fcdb7b1068f77f97dd427630631277"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232e56bd6acde3aef005df742a7d9230b3a7b8e7173df442be5e91b8c4928576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce5c6f8d8a7edeb077636a60a5a88b2948c4562138570a8e98602afbe7a7709b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2c61cb3b077dac4e1bc4e1f3d61bda0cba2592ad06b325677ed4c16c6bb6d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d21190eae0ade84882f8f9bf205b2f1984e5bd421d178f31572dde0e1fb4eab"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d308a7254d8598c41dd5505434e9fd15893828decac7b2ad8c95938c36c595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de103043b8c9a4ed821574e8f7f69bd76802dd0ff752c918d0fd001f069cf0da"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.comrqliterqlitev#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}cmd.Commit=unknown
      #{version_ldflag_prefix}cmd.Branch=master
      #{version_ldflag_prefix}cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bincmd, ".cmd#{cmd}"
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

    (testpath"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output

    assert_match "Version v#{version}", shell_output("#{bin}rqlite -v")
  end
end