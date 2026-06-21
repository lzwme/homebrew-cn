class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.3.tar.gz"
  sha256 "a81d4a2f3dd2a8e6309b3ab728c11d31dd466beebfe33d785195e85329aa7899"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e49abef95dcb786562daf7982371a4a313ed329a8354f0c13844e57c8b64249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e1d6db818c3a9fafa45f1a4fffb286e7672b5268e4307790478ef6b8d02d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc632a75b60825b790199de816bafb4bef04c7a11ea045f696b5c5041a4bdad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d557af2c843af194165580aeb28209824e99ff30dec915ee91b5a5aa3f6c610d"
    sha256 cellar: :any,                 arm64_linux:   "cfec1455cd51181d8690a009a2844fb8728ab9dea72438c45a00fbb5770e85c7"
    sha256 cellar: :any,                 x86_64_linux:  "e507f4fb015d63df47332c4334d95aa6db2fd9661c80b8c63a870e2718bc0bb9"
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