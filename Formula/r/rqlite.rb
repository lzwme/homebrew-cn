class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.43.3.tar.gz"
  sha256 "ba2f911ac70718847b42e34add05ce3e4db9fe23d13e63983c1b14ff46709ac3"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "417313cedce5e8ef6aa2f139ee73b8b620e6baee8c82ca60405ca9901fc7f697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013182cdb919564c8532e467b1f16e032c6aaf736c7c960c73239f53df31d8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac8359533876b8d1e1ad328f5747eec4367ff26bb519fd7ef0667fcdcfede2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b112cc928fa4cdb4249a78659fa9764f817a1ea2fa8f6e44b00e1fda621e88a"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d4b9fc7e35c3d4ad0b20c36f4862cc2166de64d0e2e402f684240a027eeb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b2741b423e4f569afc97c1c12f2a70d827bcc88322f005e8dc09013a8dbe6b"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end