class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.4.0.tar.gz"
  sha256 "ad837848b957bf3097d923e7f2a9a3fb453166d9f5f00e17db23323a5b15a512"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e8a65bb01cdf366926260f9ecb1593ce569b8e41676c4abf0291ec611a2fc65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edc6c3f3a696e8a326a64efda8b7346c2a7072588df86e0abbe735ae4f776a38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ffa755aa42dfcf77e0e4e9bfc0974c2bb8fcb0d8202dbb3e7a5a0cd656325dd"
    sha256 cellar: :any,                 arm64_linux:       "005bdad701ea2cf15189ba05a17908df997f8a7e5dd0d812e83db59d0d5d6e0f"
    sha256 cellar: :any,                 x86_64_linux:      "39f7e3d025f902374bff1d7083d1d6353b6c0e670b1290b668810be0cc2a9f5c"
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