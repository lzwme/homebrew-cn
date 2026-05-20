class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.6.tar.gz"
  sha256 "ec5f3fe60b4e9e908d3d745e39102f63cbea0ae1bab6b060286cf401f1a956f7"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e00caea016561092486ca5427f13dcb84a2369bee4106b0f3d80ad309c8eff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "912a80c2e6076e7b4065778b665aa04f9ebc57d989b28372232ad8b8663f20ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79835fc92b338d2b383902c06ecf713f29a4390e6157a5535c0a8b84467162b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "89fe621f3adcfa88eb1cbd73ed50bacd26ac865e5e6f7e1d42596b266bc08e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a082bac222a3eff3e20f44e7c7aefe13d69eb541a07d6040fe75bc5e64ac7549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd46ba97f9e5fcb79b5012c3e5d315b9cbfe67990f0497558d3fa2918cb9699"
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