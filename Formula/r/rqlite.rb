class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.5.2.tar.gz"
  sha256 "037c783caad5e55c84173c5dd9b3cbc0fddfc1f286fdf588408d8c02bc640373"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5686798ede8bbb0844e2a87789a63d002fad882ac39db1738a210c5dae254a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "561533d2a2b5262dd3e0681c244dc6f602fd4a764fc07e08400dfc3d8af8646e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c7c1849880203ec295e4251b351898fc2b7125bd3c1de85b4d43a163d67c64b"
    sha256 cellar: :any,                 arm64_linux:       "3dab451562d94efebc724e723ad8db4f7f55be322a01946725fa741eb4d815d1"
    sha256 cellar: :any,                 x86_64_linux:      "79a6f0ce5cba8061bbf50ad45816875ae3dd53197363ddc704323cb14a0345eb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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