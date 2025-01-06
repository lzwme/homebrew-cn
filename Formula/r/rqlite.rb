class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.3.tar.gz"
  sha256 "c57e1499e013d69f2c0201a368546691537a67388e967c38c03948a9ea208b57"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b451e822973b5e4b4a43cc8c89ad209c89924bd4941463898f41eea2e62c440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09c49aa7345302d6df2e4950185ed53e89599eec8b5267cbf4e37c18b59a9db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d662a7fde6a4a9e96c6f1301b55f00c26573de652fb878a7ca6e5a79896e5228"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4ff94da1f66abfcebbf0d66f44c2c951c7449ee3def3f9f2aa5695639c15d5"
    sha256 cellar: :any_skip_relocation, ventura:       "7e2c5061e77c9ca2fb59edffea17513fafbb1b6cf5d8283ad2861b16406fc828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eb30b8e4060053b3cb1fb302f1a8b4168eac1223580a3aa8591feb80fd09e99"
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