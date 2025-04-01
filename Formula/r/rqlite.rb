class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.15.tar.gz"
  sha256 "94b6fb1319bbd9429dadb554120a5b81c50763e5f811e27b728f41009dec24b5"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5c060cd9bf47a4edea3a77bd0ce0adc6201a7db5f4aed022d8963fec2febee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da43dcea6c8dbd1ce3d38ee84b123008a5153edfd678d17a31f3216cdd509407"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abbf8f070ef5a3ffd2f2a330abfbf1a8968161f0f5d06e42106aa133b55145b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b774aebd5b0c952d6babb59e16d9cac274737bb21064359ade0d53cb278e4e44"
    sha256 cellar: :any_skip_relocation, ventura:       "58ca377a3d0edad285daf8accdef6893080213dbfb48ffa0a2675f76e01b3b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289fe54e3140f8ca3ba6d7a2ec716d988c15bd0f83444dc2cf3cc94e20774a23"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.comrqliterqlitev#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}cmd.Commit=unknown
      #{version_ldflag_prefix}cmd.Branch=master
      #{version_ldflag_prefix}cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bincmd, ".cmd#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output

    assert_match "Version v#{version}", shell_output("#{bin}rqlite -v")
  end
end