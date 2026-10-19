class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.6.2.tar.gz"
  sha256 "5c13048d3d7e67174a49b40e4f10656654fe575a115d7aedcc85dede7da4fe1c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "043a6fcebd29f26de72cf1c912d3eae05c51c7752b8d6c32c60193c88ef03ad6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4b92036d783dff0b966b115dd3a44c4a6793a66c26e83c1a24b02376d33029b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59bb132318a24d05f3319d5d057fa831299f340d630a1ef29d3e74de8acb98b0"
    sha256 cellar: :any,                 arm64_linux:       "324a7f6995d64981cbc702ebe3849f2b92984474f4c896b390b12b028fac0ed4"
    sha256 cellar: :any,                 x86_64_linux:      "9157c111789c4774e486ddabb286a4d01f65da3253307ae556f7ad9a91a42368"
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