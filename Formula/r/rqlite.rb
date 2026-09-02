class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.3.0.tar.gz"
  sha256 "bbf2c340554307ab3b0abebf1f5b42c0b5c33f7fb167f83ae8ffb0d1736860cd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c6c95899a7c4a0bd74b7a3f23ac2f5b80793fe2dc63619d448a19a10ffd677d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e18fe37fb464efb664d9b50d4d4499da492e0029abde94f3f2fbf24e06a6e83b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90cd28c466f1196157ebd1707efb0a2203c7e656468ec66649bb8314676a9d50"
    sha256 cellar: :any,                 arm64_linux:   "687398161a07abe231b9a241da832c2dcbc2a15b18a76a0344083f7f76617c5e"
    sha256 cellar: :any,                 x86_64_linux:  "ac7cd5f483b76e92f175bb2fc64e86dbb4a7cd6feb126113cb3b2dfd010fbce6"
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