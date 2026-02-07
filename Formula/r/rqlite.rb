class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.4.0.tar.gz"
  sha256 "b5e6e2aa0f929e6072de7c27c0e750969959588474943c0b134eb69e3e7db5bb"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c71440bd7b107baaec8812972ae1c7949e3c47a9174ef0720fd8c1eaa9c12b98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8fb5007c48e700cdbdac05a6254e10a758b4203d7a0442f2efe3dd9e5ac02d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "363b14abd2bd8a5fad9d76c3faba3cd5a35ff5c54dee2d50a132da989777f66f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb1d679cf4840991cb605656fa1f63d8fdd7ad14c95cfa1a856901d2ddce01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833bdc511aa778f26e992a3dca22eff8b2037bddd9a4ccc0581cc98dd429b16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4ae09e2cbf1ba151e3022af6156f11c734153699789d5900dfcc6983ecd8054"
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