class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.21.tar.gz"
  sha256 "abace877991382f7c53cb2b5c5d5ccb321dc94ea2a1fbc13359792551e0537e8"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c49859c507b138c167365aee8b59f26c774b65282c018c512bedc1cc937b2a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "595f309dcb5021086affade8b1fff197e0c98a249cd1a3c5d50c8b49c5bf26c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c282a753c6f7249b3b090db98d8a37f74c26ddfa2f4eb7fedb33c0451d14e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "b86e319ebba8c5fe0c1e611c4b4bad418e7e9b6f45ef4f67d1a1c00045f29f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14d9ce2bcbbb0486222ddb5cdd156fd735ca54020b184fc5a09ac06ceb0ea21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbe3de23b92f32f83c544ccb4406cfb5f7b6820624a30c18d41fcca61e13bed"
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