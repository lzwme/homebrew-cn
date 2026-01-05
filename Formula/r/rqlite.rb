class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.9.tar.gz"
  sha256 "38bc59b7a2e2b884e49779f8fdba3da861037066c0930f313fff9db7d7e432a4"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "132bfe670d43ec78cbbcd5dec97199ecd414118f347cc6916f895a557fcca646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b562fcc724dbce071dea244b4cab08bf833b01df35ca3495b6e47133f13488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e06bcc417e0b3eada172e71efa6757237fd8f16ff550faca79c292ce264b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "4540d2f0063b736ea82dfaf0d3c6c89db38835699b9f4cdaba3fd701b904db36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58009164f2a3d830ad265d8230a7203a8c473d691f00eb6431ae7ea1f8dd27eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39f20cb8ac2861da548a3156d7bb2bfc6d4f434eba34803079c70072d0cfbcb"
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