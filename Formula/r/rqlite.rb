class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.4.tar.gz"
  sha256 "30464a5630de98aa6671c208b7f1abae8262b75e859035894cc0f584a13e7575"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a7f0d8843cfb4b98ea1add6b8658ee77379fceede3185c7fa2701f0301b3543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c667d4cd58e8ca6aedafd4563612563d8225c4aa36ca5126e4ee9ab912859c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87d305c42e2e52f7261091ceb733f5834126691111b48de2dca7943e167dc142"
    sha256 cellar: :any_skip_relocation, sonoma:        "58e1d48d213108071653213f53b8422406205526c629ab352d9ad12445435b49"
    sha256 cellar: :any_skip_relocation, ventura:       "3253b7766116200e1334a1bc50d49a0ad19ca7c40be7605fe82c21f1d9789582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "382bd14d8a474f4ded7a62873f0b8eaa27325ce655ab65041cf66ac9b428f1b6"
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