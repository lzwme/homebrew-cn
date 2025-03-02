class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.12.tar.gz"
  sha256 "6a3165bf226499ed6a599f926dfb81458d962826961486cd417b488db0b167fd"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a14d240b54b90ed69da883074af13a97bfc44e01a926922e21bf67bcb81af15f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3c8c596a513a88e6169b662c6001e780f95cd4c867135fbf2a3aaf18569e7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78fd41a49bd6696052af10dec67fca6c310150350b03db27c4928d9f6d702500"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20a56e5d0f4b7e917debd1ed97ce2b6d058c5b0770e10addf28bd11a04fc5d1"
    sha256 cellar: :any_skip_relocation, ventura:       "2597cbde41ad46113065e318525868d750d8d2a0f06bd72334bc9e34449504eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c967655447837df0b8f6b0a406dda020329e3dc9dff536b139cbea72f8c7d89"
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