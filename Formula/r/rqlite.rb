class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.0.tar.gz"
  sha256 "164350e755837ba7c2617bc6071a56ce3de89b1f0e380a7e3c947647960252be"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e4b919f83efa9d433a8f0e81dae3601bb5ac318fed60135534fafbf19a8d85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dddc8309b5ee0bcf675a41d7b637f53e31e44c492effdf832d55467a95b06e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825cb08cf2a2bbbd159fec8b51551c1e562dec9a6896205f72f2c3bbc61a021f"
    sha256 cellar: :any_skip_relocation, sonoma:        "833a45ba5d12aefa9aab2dbc9b8add2460f5b877c5c5ed4e20e8dd175d9171a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5181994aa71ec3439a1a432183d23132c14fa7dc395004a88d15232b82578e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43442a8d90d283c5cb911a29c37d9b3633f86b4480900af741425d61d5db12a1"
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