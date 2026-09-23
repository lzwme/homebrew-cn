class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.3.6.tar.gz"
  sha256 "f54b8dc2b84236b298a79ca181267194753c00fcd8cf61601a47e1b463bb467d"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "263a340b65c411679bcef88eb0298f0991070915835fc0911efbdecd79487345"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8611881d56827041bbb4db797bb1584c16de9e43394364e0c533014937ce9d38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5397a0d4d4c0ca49feaf4a49453a7d3cacf2973956c57ef9ad0123e2c356f69f"
    sha256 cellar: :any,                 arm64_linux:       "b0c0d183db23d8c2a40a27f8f38b6d121a443eb6ff6e92a6c3da17d6f5303c9f"
    sha256 cellar: :any,                 x86_64_linux:      "b4bfb09fbd44d80af2a921b5348e2f436ec1f9617e38fdb4db35c3b0d1673498"
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