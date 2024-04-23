class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.23.2.tar.gz"
  sha256 "0640d7c71e123552557747020bafce50e4e8ef92bd843278d4d0c5b1d56714b8"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "facc243aa93cc62ec8486bd3e7a4091c1dfdfa9f4868a4196e76972c1819782f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b7fa8e5bbf1a3563d841be22527553e47d04d4ae9d85ddae897fe76a07ad139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea7a9f9e71efc70a8a64adcdc565fa119f2b74542cdbfdae29c6eaaa736ead6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ae2c8c8f23fb41a7a4abd6e746ff637c053d7e2de71007769743d95e068832a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e6a710b44ad05313f69333b3b408fadf3ca444fd7978c306083e00f622923c3"
    sha256 cellar: :any_skip_relocation, monterey:       "c352b3a29741405cad93f88e501824907bafcc9230eb58d7761a4ff2a553c6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6865acbbdf1b157a52b8156ce29affefe388709c9a24af313ef71dcccbcd70"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bincmd, ".cmd#{cmd}"
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

    (testpath"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end