class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.20.tar.gz"
  sha256 "a158a2f0dacd65d1fadd1c397b83cd4c93946d919c819201f0aaafb919d4aeae"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57253eea6ebfc780a6c4d2d462d957eb0f5cc0b3aef7095fd296aa8072151fee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e739cbd5173bd51ff91f718906ebe5b8489ddd74883da1dc796c6457b9d7f0e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4234b45b1f0e0e537c00b4be8b98505e413e9ae677e89dc32a1b5cfac4506ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "81afdb218791f2e021285bd2c5089cd6a986561f3a8987a8f20e04aa8ada0d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52feac03cfafe2d095650f18060fb80277028bf1505bad7ffeae5425f9cef62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975b7e43ca85dc820bf990453e0bf32af79a2972374923d0cd83488971075c20"
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