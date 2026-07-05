class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.6.tar.gz"
  sha256 "ab3d893f8942a25a68f14779fcbaaddf571424b1a17c82e8603edd0122a20d48"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "701d22a5a0d889fea5a8ba6eadb0efb3f7d9c5e6f75584459173962903f7fd42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53ad76920f1b24441641b9bc08343a523bda74771979948e38a6cb5070b6baa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10f505496a1fa06d9f240619cc9f0a9732b91504842ca46fca722da1b570a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28e577d29f0cc9bd84746cf847dd89518f11743a9b00d2b69a0e8f55e5be648"
    sha256 cellar: :any,                 arm64_linux:   "9691935d4e5daa4a21e8b5bab864c209c4409e381dd8be2ce246a890ec232d4c"
    sha256 cellar: :any,                 x86_64_linux:  "699105dd85b5b012e517062a058202e9c057376b4f38852b765cca59a8694047"
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