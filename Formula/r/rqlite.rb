class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.6.4.tar.gz"
  sha256 "d78f59fa7631458a7379c6278fc6a7495a6e91dc49ad964e2d09c0f296fdfcde"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99535bcf2d1d2a15c2fb5324d1f953230a70ec37309f2fb9b28254b442af744d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9390f5abac07da5962b5b3f1fc931de1d6c35e6bebc3c5e9b04e55fc04698b2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5947bca3c80f5f18f4d22f5b9b19eeba436bcd49180d207b061f48649a6d16cc"
    sha256 cellar: :any,                 arm64_linux:       "8be73d596d8f34f810eaf4e46f44fd4e7299fd890f974dd83e7a3a71b1e31f1d"
    sha256 cellar: :any,                 x86_64_linux:      "1185d882c38d3668bd297230011777f51a47e111fa2355587dece7e586aa5f7e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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