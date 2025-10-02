class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.1.1.tar.gz"
  sha256 "d4d2387fa046606b53ae34831f07e4960c75a0a4dc54e60a05102fae33ce18bf"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b413f305638ff860dfb1c8c6d6bd509288e1a45c80b6300a92323e3e3ef5d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc3cd6a9353fc3dd0b94631415bb121ba037d2238e57db1bc236949f70be5d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "534275148e67023095523273b1379c264899b9ac3c0b91b87f3a445a3e21c44e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b03a708eb807f19ee448a1684f3a4f7998cc7079dd2ee4edd4d79cb7d7fce786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83324e320679bbcb3a7c2ceadacbfef7d68423d74cfbcee4043cf951e21733d"
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