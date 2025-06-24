class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.38.2.tar.gz"
  sha256 "b64e4168bb55286587d6d41b9fde7df06c3fb7f767c78d214d4b0b49915bb80b"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf48c27c5bfc03f531b0cf691efe5c307cad121b01990c0c93bdc597fc35d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2238f5be8568fec962216741189dde918638bb6cba3379de924997f11d45e42b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc1cbdf06ccb8130f66fda75108c9b0cf637b01eb415930336c4b93c30d5e429"
    sha256 cellar: :any_skip_relocation, sonoma:        "04a6659bd0fa9ae679be0f598e2eb52a07d178c31fd2c15b8eee455141a6e5a3"
    sha256 cellar: :any_skip_relocation, ventura:       "f5d4b144762e116f8887f94518f1a253f2e27d43d3f9ddc831b6e92235b7ec1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4901fed10f4af2585793edd0ca8db3514b662c805e551978c5874170a5c93ea2"
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