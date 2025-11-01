class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.2.0.tar.gz"
  sha256 "f7f78ca96648704a26eca49f7a4607f901d325e47f18c30924cfb8b2a2cf17c7"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55a7af126d29fb399b3aef276cbbb77c201d260b1c1d6612ab964db2ed864391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46d5e85f4158eeea73c69cb9f875943dab5ca2a842aa220fa6ba4ed4ebb7e7ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "321f9f10f656d09d8fa26040521dbebbab0f57ef7f1d9e0f036f64352461289d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c290c838aba4302c95e3989fb8e8ffbb53050f02c07a541ed411269184f8773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c788d00ee7e615d46b55319ad868b0e39da5eab6af31e26b14f9dbd26c3d97b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e029add514a61263851135a41e5eb277eafe839c08c5201b1a0f9961c16e57b5"
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