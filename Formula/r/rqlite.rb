class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.43.4.tar.gz"
  sha256 "ce9359fe8801b4f78caef14779bca50545df6c4f1cddcf978fa3609262b8ea5b"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978cbbff886729efb06caa75878f8107d870e0f46f3fad55e1d2a259a78e99e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42faa1117ba6f6a5fb6db24fef27822fcaf921f0448f4be5a3bbf864669628f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "498b862f8be5a49146554c18ed02e2a56d7e6b351b4a67faab85ac6b37dd46db"
    sha256 cellar: :any_skip_relocation, sonoma:        "397b0af5f10f430e60d60c7e24461e1957e60d8f9fc8b408941db1ab9beb0096"
    sha256 cellar: :any_skip_relocation, ventura:       "301b72033eb8fb7190ae69ec56e63f526e8c26e8441a64b56dfc04f8001f3783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d786e8893357437aebee6f4b35b69780deb752eaf3a74188d9502250932f32"
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