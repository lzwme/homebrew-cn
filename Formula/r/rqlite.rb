class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.6.tar.gz"
  sha256 "7c9331ab87f207f5fa81df59e9f48320e3029cbb36bed8fee7b9177fd3be6c12"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb82f6d7c25b829b509cf155bc0db602576174a1800e5681ea4584d965301200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75cb6549d8d91b618e9316991ff04d60aa83abb656295fa85908987e226b9c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505515de266bb29cde599bb77421b9410255ad82363844d29e82b90264a608df"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccf1c1ac71ba86c117037aaff1435f167da955c5c200bdc69bb952ce1ae37814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f8606c8d6dfa86e9eeea1ab247666c8df11dc58163e6e356077650249066a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c543578d558d19e37e8806928cbd7220890cc245eb2450d565c8ac44d4c8db"
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