class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.37.4.tar.gz"
  sha256 "3a5ded65609a7f4b9562ab676593f324784603d4de9047b8c80732d3f71f1e67"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c09f0ea09ea1398ed2b766a4985664fe92e57dcc769c13f2a15d0d17e3389d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9796dc964bb4225c11762eb936781c145bec06a6d56908881f8ee3850152c02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce5355c27d6077d98b672faa3760cbc3a3b2970e4b54934ea2d302e7a8620c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "daa6e6bdb03ab18959bb0e6056ef87103709e760c8c12a602ce1a0292033dcf0"
    sha256 cellar: :any_skip_relocation, ventura:       "2ebf129407de941fdf6737e8c27afe86e86ed11b6ee41929e9a8ba32cb2948d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "849a289d0091efcbaffef224f17174916c436fe0907ebc3b3f7cc22732110d5d"
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