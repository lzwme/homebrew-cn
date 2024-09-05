class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.29.5.tar.gz"
  sha256 "c5168065e6aefee5616bd2fd048eb0a7bf7e443fc82c54f44b2ef10c42a16742"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f5c86b891c1292a1e64974b4c7c6cb7e81ecd3e5b5ed3864793cd9904ca6cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ef67f7876197a7fe110a3fe075375e3e4c2c1b70905fd8b264f939fc2d836c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d5a140beb601e3e6a7f02bd9501d7c075f13dfdbde2df5b8aa7d46268c209d"
    sha256 cellar: :any_skip_relocation, sonoma:         "708bc37331070c3c83520efed128ae795acec4c0e7469cea365c304b036cb03a"
    sha256 cellar: :any_skip_relocation, ventura:        "cf55f3f842e66dcbfeec0611f5373ff513a25450769092f68f2cbe2c6ffea408"
    sha256 cellar: :any_skip_relocation, monterey:       "eabeb7c98ad499e1f7f05603a8fe8aae5616474eecccb9d19b134d16df3ff7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f79cd45d077f47b8a51992a826624a52a998a4806159816bae3fbc5257f4d76d"
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