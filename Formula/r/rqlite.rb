class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.14.tar.gz"
  sha256 "3a62287d381ff1e022c350641c076d1648df4fca6879ae528fea1275acc6289b"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "924207d93ea1b7e2a73bf6f0087f40761860a5391fab8c26477b64f2da1612c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57856687e9628bcd78e9e563ff9cae0e6abd9e8c63d01f8b1106815522d0f9bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c53753c5a15deb615a38d1df202cc3ba4942d737ace280771a7785e57dc483"
    sha256 cellar: :any_skip_relocation, sonoma:        "abcef89a8543f894de84370506e4cf13e2472e008b113e239f090a74bba42aea"
    sha256 cellar: :any_skip_relocation, ventura:       "509445cc39952ec91023fd03354224bf233a75e5c4e6fff786ccc2cd66186f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d25ebd98f4dfaa679e87937681a65a9331e038536c1256c8c58fc1ec05f26c9"
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