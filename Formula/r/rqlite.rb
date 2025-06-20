class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.38.1.tar.gz"
  sha256 "0e47a00411b701a9d0c98541b2b772ffaf8ecddb3edfe9903e7473c009dfdf7a"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a2d8c8b8f52e444eae39c446b61f764fa154b114681234ee132cd849278ab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f94f7650f3922c1bacc97aa5f81cf27165924d6d0f9f0cd08a446371bc9a3c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be6d909be66b376368679c8b40761d2e008abf257f130d0f31de1771279f8cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d6c95cb3e778da35780c417b72c307f7bbc72639766020d3dcccbf4fcefff95"
    sha256 cellar: :any_skip_relocation, ventura:       "47affc6fd0da4279ae750a6c749f55d332109d298f651ca27dedecca471b368c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c7eb1942917c98b1e4f82283078d120f8e3801774e1dce9d9cb9bd640ca1a9"
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