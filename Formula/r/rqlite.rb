class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "56e2c10db24aef5dc362f65af73d71b2fdeb63d09efefae21fde83537513401e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a1da2283e970c8f843dd0d1c85b1c940011298c1822bba2dd336aed6ab117e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7962d08f6464225db0a0fe9d0d98fc05469ea4b1743819a4653bf50f4511d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b2b8c113f0aad8020a7812c75d5777733a7da810797f37a8b652506b6d50a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc897ba689af60d1b5b427117201718c3bd4b07e910eefca91c7748e30302f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e0faba1c115bc03c64196b7795d86bc98ccae6032a16ea2d2208558f58140d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1a08c246169b3c222aa3b48644a005fcfaec852a6b7865f9ec1b4c63eb5704"
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