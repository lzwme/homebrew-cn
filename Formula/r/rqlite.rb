class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.8.tar.gz"
  sha256 "ee39930c48c2ae7f9451f25c1b2e69f021c3884d73ed5e1e165e70b4f4d2317d"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f9d7cacfcdb874d667ecb34a6fc8c9d5b3eec9fb5e2caa384092ab5e059bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4631317aaeca3edce800b6a1731fe0e2903d41dc6992f6f96c4026cebacb5a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45019d0bf58e0592d087f5e538134eb679a18dfd6a3edf42dbfcc1c8186ad510"
    sha256 cellar: :any_skip_relocation, sonoma:        "7850d3a0e404e9851bb0b56446058bd4d7593eddd58e3bc9673119f750b3c1fd"
    sha256 cellar: :any_skip_relocation, ventura:       "522c752687b406bf19bae2fb9fc8fce97b1297dcc2c2dea50c5b26c9848437cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf8141330842bd2c5ac1e26340671b3c92e667df8d3f250846670faf663e05e"
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