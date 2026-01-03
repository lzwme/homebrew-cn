class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.7.tar.gz"
  sha256 "045cd8e31802751aa00b2d0682b027eef88661383ded9d021e9cccdd076f6b04"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f847053e77fcc740bb4ddc08dfa59f9d31db2a3d265a4b8651e6ca0060e3e260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea2cb839b7281f0386e7e2e3a32952d75a68d94f782fd936941246e1bad39479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5688390b4e5ab74b356b781c04eb0cb2609354d36181a37c28f457adfafb65cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d09caeea975e4e4149296eec28614091eb56e7651e772197b1f739bca1191d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4943768e12fae254ee0cf113822cb07fa3033ded1469c7f46949988016a4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3f18027a1957a9a958df15ab0f1de3a0dd90823b8356b51c46c8714b76b187"
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