class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.9.tar.gz"
  sha256 "caca99548dd3fe41b8f473026396b4ace6666df45ba363e38b8d5ee4be835db5"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab2cdd4a89b6fd6040c9d441d6ed9759aa4b402048bcccd87d695d106f0ea5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "193dd5da66d6cef024b7ca2f7b8fe9f8ed8d47efb42c711c8371dcbb4c2876db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6998b960fdaff68e94cb4fd429fc4eccedff7360e7dce47d1fd8e90710868dee"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97e4d6e43d8edac5d3bddf48ba3322ed52f43a2c76a3d67874597a051193010"
    sha256 cellar: :any_skip_relocation, ventura:       "4a88864a3e5ec989a40b2158715c47c2f4feb951d408bf8079e6bb29c0ca9b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012fd3e058f8f91292df0ad7d5d68760e0c9ba6694452d784a4c25253efae373"
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