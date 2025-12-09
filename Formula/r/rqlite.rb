class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.5.tar.gz"
  sha256 "1459de455470be70d98e3165a8d194dc66ebcdd1dd8066c4abfbe1d00f5f170c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c28ea04a3f60b680d0e8695614813392ff8d3e946e19d43adec812de985dcd97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2672884287affae1f874b35e82cc49c7361705ca4c3710be81e90ece25319dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2574caaa4d2d0c7be47b011e75b7d18c181ccfc3aa3993fed0327ed9e01d269"
    sha256 cellar: :any_skip_relocation, sonoma:        "29d20fae267c2ba904869527c98ac7fad6166170837f18295b768b59cdad91a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d787921011c874bb4b9e6567b40cfe4084967bef302ac5f198c4d194c812ee26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d077f51af108f0c5dede3e3a68eade2ddeb912c1d43509ada51a10f6c3ebc2"
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
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end