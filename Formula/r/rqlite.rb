class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.3.4.tar.gz"
  sha256 "6c7f8621c69d0f67f00a34f62f1b8c8bb92e2dbb2fde6455769948bfc1127e2e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13ea7815ba5218bf4f2d1b3c030a82564b17ade8a9495aaea5eae114e251cfdb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d8a4a57a3a620835726d80db270fc5a7dd6ef5e9bff8615f7705365958d11f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5618a4385d73e3bdc58facf36a816dba67b3e9513eeed700e30ca1445e38ccd1"
    sha256 cellar: :any,                 arm64_linux:       "c3787c3b034a91ae2acb953fe9af5a0b0fb5399ab5d1279d3a5cd202ce24e2f8"
    sha256 cellar: :any,                 x86_64_linux:      "a5a59d7f96a71b3ff44093c129a0ac9d23a4eeb9bb3913d31dedcbff05057ebc"
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