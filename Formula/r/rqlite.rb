class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.2.3.tar.gz"
  sha256 "9861fc75a005c5546d2bc5e4d030ddc53d3581d69a4126f3764cc5e0d90f8fa8"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03bbc96e1e8c38668665d454653a7ede8f10b1cf88f51c037a2d022328f83b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10fe1a08da10c0f623fa2bd9735a350851eb3a2af938312015eb66d315abf63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d33eaa0707811f2ad7e48f0129925562d2fa8ec5c03fb4eccf39f06070b0e93b"
    sha256 cellar: :any_skip_relocation, sonoma:        "510a88a81e419dd190e2ba8bd4985e2f69ebf35072a66ff405a14bbbc50c96cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2dac8c80f0c0f4ef1aa36938111e37c7986476c20dc6de66594393e88b97108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b34369f5f71fcd5ff5523f51998babef6e225d1068539013c04f2e42a7a989e"
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