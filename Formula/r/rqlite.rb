class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.6.5.tar.gz"
  sha256 "7844d1027ffe2f71f8bda8bd07730d4e35f5a24f4acc068e07b9bdad01a9d135"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9f50f160f0c4843ce122a0b44d05e4c8f5024474f9e3e3f61390e43c850aa27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53270d55dd95a8346de0c0d3915dfd10ebfbba44b82a39c5b3aa9246cc48a933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69c2b9ed17901205e722d3bbdb7ff4110f18c53981a0bdc3381afe309c9bb79d"
    sha256 cellar: :any,                 arm64_linux:       "030868722b14757b6b05a646b25691ea9d4b5cd16ec0cda1d69685c069b1fc4d"
    sha256 cellar: :any,                 x86_64_linux:      "84fcf1023addc13f994a2848e1611d146f4770ef6669f5b43d17f6195e246886"
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