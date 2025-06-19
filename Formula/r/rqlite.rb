class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.38.0.tar.gz"
  sha256 "ea455cc813cb438b339489a96d9ca485191eb1ccbe7f52bcda87b80821e486f6"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aecad2297d27959987dba5ade6dc097e46a2bdbfc82287a98def683048834453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "501eb08f130da93ed507671c70dad6cc6a1cd55485ef5b9905121d756263adf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "518153b2d3768eadf88a8cf8e40d677ba87529ea9c66719201a8c51e28dc0250"
    sha256 cellar: :any_skip_relocation, sonoma:        "399abb8e207437398981f3e1072e724044af6b4107647923cbea342a46d588b6"
    sha256 cellar: :any_skip_relocation, ventura:       "8a51f53cb5d0c9ed724933894a219b5f1161ad93b8b1ebbf84946530611ead2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093bef068207780213279c404a53003898afface80535ceaa36724aa537f993e"
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