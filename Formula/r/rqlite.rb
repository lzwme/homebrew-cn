class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "eb3399776c283fd445919c07e24740b91745078de933f03e9a73ba4011756ccf"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7324aa91c0dc2949795ad4808086272f9661b0ff073a0c24244530c54362ead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "761dc65557d4f60e8fcd2107effd76bb5a43a39c408ba0f1c45416e556979bca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ab36cafab4237f16e04aa6c4db053af0d9d7039187999587d8c73ce263c80c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e78e17be0f9c4a624ad4be684d24dc87d4437d63498b58d2515c404f2dc40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43d7614740cb5af566782c8376f87342327292c71acefd061470f3133fd2b20"
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