class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.43.1.tar.gz"
  sha256 "66b1155fa592d313e4415c82697da4f6db361802d85b3b9651ab9648a10bca40"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd3246164037d675a97d6a693d496cbcb2fd2aa5a40c7c4e77fab83d104fea4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d992ced91944629b2486cdd7ffc185c828f785de14192283fd08ca295d081b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b97978db3610553ddc0df5b51bfcfcba124b4eb6afb7beffaef344d2dc8e5b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f095ad6384ed79eafb2cde89c5e041749267114216d50d431b89f82c2c85c97b"
    sha256 cellar: :any_skip_relocation, ventura:       "6d2c74e4bc376186124f6baa83eb022646b6aa21ef23e71f70e2c480c6f9cf76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05a0f4d1c6fb245ac046fe161fa59892a0dcdec109286c6e0de46306e172da9"
  end

  depends_on "go" => :build

  def install
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