class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.3.3.tar.gz"
  sha256 "ea1de6165ef6cade1489e24b22c0b305487ea675ad231a213b40a199465c076c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e66ee25657de0b6cf3803077d1665c4ae73f22a191153d58a911e2ba567f5e06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2f22546d27bf603218849a9e370012d66d95fe021a82565adc927bc5f2f7005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69afa0f2ccb3f957a84d59f7d0b45b11c95ef9889f82ce8da67310bcb40ce7c8"
    sha256 cellar: :any,                 arm64_linux:       "40951f8cf4a4a391464c1be0a80f05f57abcaf7f34864bf423aac9062141921a"
    sha256 cellar: :any,                 x86_64_linux:      "20d4c5331f7ebb360defb5c3f45df3465690a977a67f8113d7b8677f4dee1c3d"
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