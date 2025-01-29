class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.10.tar.gz"
  sha256 "ed3364e6fbf095821da08ba440ae9bd6dc93490f960b24d0c8cf286a5b0bcefa"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721b24715dc46d9c5bd86bb75cdf9bb1822fca0a60f9dd7f641a2992d932b121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c854881e7b651493dd95e48dd7eb0835f77ec43216a7aafeaa56c7534d5894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c17e4b71e771f7cd1872c7706294ddf49429ad2d576e0ece22d61dd2a9e65881"
    sha256 cellar: :any_skip_relocation, sonoma:        "b17fe95e38a7f1592483598e7b6cc252a4e8ffbe9a5c909f5e7342eca1e8148d"
    sha256 cellar: :any_skip_relocation, ventura:       "6a7eb8a0fae1a6c7bc1f8a147c7606d4ec871dae66587c590b364efe24bd8692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "075b8841f5016e21c2988abe38d7bf3240bf4acfe8b45cf022be5b8aaab34107"
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