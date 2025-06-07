class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.37.3.tar.gz"
  sha256 "e63071ff7628a067f856d8d4d2e52784c2d7c15cfb7897f5a6accf31e6508e0e"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840bd0bed8c4df8e4a3b3e92d8345bfce01170d12f8b197b4f0b0a55d5cb561a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "570574337e009380b38d8cadb8137a524044c18b1c303ac2b99b1fdaff8d7ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fe041e38a97c1c19175c51d40f9433c0ee0a39551fe6bb92d8d23436c237fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c5bc2bed9f20e99f9c610166a6235b18c6f4a957b995753f6c82e115580ed9"
    sha256 cellar: :any_skip_relocation, ventura:       "ad917d454ee4d223fd69ba242ea080f01e5c7233eaaf5cd7e43c3b05123c78b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a02b53adf214032f2cc6a769e4831dd3950ef40d158b2604abcd4d45a91b52"
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