class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "12c6471993ccaecee4288a2e02f3a19b6a8bf3084b2e567687ab16381b8b0585"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baa41ea219cba7d0195dc0b0423280d8298b5110855893ae053c7f599e76c0c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e83ea02bf7d6cb563668531914fa9eede53e228bdd70ddf50b8440fb674f6926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63257f7cf528650f5b9e79a0eb62fcd2a69ebdaef2eb782371dfec4cb63d9e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e7cea2f441cc3073931f1808bdb60cb615bee225765f65c148023f40e044b4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b4dad0e1cbf6c5230a7eb3e18f9d6078d4a92d4905f2c8295e55adeaa965f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee2509558c28db70d2b8f0079b339fddba30312f0f88c56874e088c928975f2"
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