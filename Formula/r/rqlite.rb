class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "5c82dad5fdad79b83246c53199fb4831117ee38525a79a0b365c90a3bbe22c6b"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2fc11277196762f1293686cb6d251d3b495a753723b6f2627368e30b001bbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508c26c0ae34e4a7340e4c109b7d9c01e0d240540cfb8c3d75415404e206e67a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c235b8237d81e5f0e66b63f3fb4ac281b23853fddd0b677edbb44031c66d220"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e955527dcfbbef3c78476be1fe9b029690b4ebcd279d52dfe18a0a091fa77bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cf14031dd72a0e59bc269abe11960a22192ebbf093397c88f3051e6aed33780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11337a49dc1d43dc27a63d1cd1fc0ca4119348df20d8ddc1f9b609f3af6f403"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
    test_sql = <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL

    spawn bin/"rqlited", "-http-addr", "localhost:#{port}",
                         "-raft-addr", "localhost:#{free_port}",
                         testpath
    sleep 5
    assert_match "foo", pipe_output("#{bin}/rqlite -p #{port}", test_sql, 0)
    assert_match "Statements/sec", shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end