class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.43.2.tar.gz"
  sha256 "8517b6333c8237389695bce5145167aa74cef5db8d2c905a4db09a509121b5a2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d229f0a42e40900c614a6ab2c1ee4e31716e8fef0ce6c4916fab1b3745a6a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cebbb722e84c998a7b10864fd5aaa83bcd160e7388d40dce8c281c998be34cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c50e0bc44347ea047540c02123f86bada9038f035fa947acbfb4377018b530"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a8d34606ebabf036a3730a8ae100fccf55b08b4e128a57be9e30c487336d0a5"
    sha256 cellar: :any_skip_relocation, ventura:       "5fb9f887487c206042b48b4568423b848466197194d5b79db31f2dde59b8fb80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af439074b7a95e8c035575cc1afd570c4a7742ca081c5218ac53dbc92ff11097"
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