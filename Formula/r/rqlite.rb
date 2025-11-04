class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.2.1.tar.gz"
  sha256 "f0149e30792b3a2b8307e20e3e4dd9739be6dc22e0228c56ed989829d8d5245d"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c2589c6ad4ea1dbe3701301440ea7d4c31844e5ef75ffc4fe2f90d169007a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c2e70816e61f171b3f038d9e3d1eccb2f4ea5f8dca793f1959392095624577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "638789b524e177a49e2bece28155e72fae9e92ec98894346f05f4647cda21cb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fca0ed3421eebb32930159290d883e8b0d84c722d4f28dbe434743d8d9bcd64c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d8ecfee665c4a36339db2934c421ba664cdd00f91cb4b0ac58f075d0d74833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd644becb01a8cf8dc5ae2c8cc25e3af91b3cc18fcec2bd00d522e09462d9fa"
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
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end