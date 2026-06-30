class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.5.tar.gz"
  sha256 "1c2004ce57d8f9e14ce2b5c438dc3dd8839ce8c1648895b8910a2541a7f83979"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0dc4ee47fddee8d90a2cada1b47341b23643254aef7406a8df6c69e161bceb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af2ba255a3ab9a7bb5d032ea95114a53e61646ec3814b36c21250c935872ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3d2ecd05613567fb7510c64c4cb856184178f474f25c2313faff2f0a49fac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78b962527da66c6aa0d9251591e8dd7680f559df1a77817e05f3815b7196899"
    sha256 cellar: :any,                 arm64_linux:   "408239dfa34ab9f5ead090c8b247927d30d949432190e988082b2e5755787809"
    sha256 cellar: :any,                 x86_64_linux:  "6cd83ede3c7631a21afee3bcf86f327ca4b2eb9e6d02e411e2884b6b888cc706"
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