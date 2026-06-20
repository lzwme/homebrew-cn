class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.2.tar.gz"
  sha256 "dd05caca9a821b0c2ac50edc2890e23abf9a18674600505e6804afb4e55a0038"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3841b99c1d5b32cf4a2baef6e3162ebb63b5088e9266ff0081b272f266a711ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b135235f1e7551827c8d9ebad5e32381d5b185217c7d385bc5cdbb3f0f919821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68a6d8f7926f1086bde68aab2daad8c6b3bf050781483be7984764c488e5da71"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36ab1a098fa56c9e69a6b9d0652fd1dee96713d4de51ca3554e1f917c6c23f0"
    sha256 cellar: :any,                 arm64_linux:   "c7d0dd8dc672ea59876166e6ed665dfc4ce8f358c2da32fd4000c9996ab68bd3"
    sha256 cellar: :any,                 x86_64_linux:  "c003bdce0201585b8466a175671ff23cf6801b590b30029b8d69e0d0f739ba9d"
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