class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.6.tar.gz"
  sha256 "8f94fc2c3b2866e6f8890bce76fba5f281bac8efc15c8f2afb064bad62df0317"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "826e8a2b09602b9679493e2c7b7e9db260b65ecbe1c1e2e42eaf7f68b7b0e419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd4b89a38296f086f92d055730b6a0b70ccfb082b192eb09698e79ac170e03a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "049bf3ffcc36906bf60ac4afdec11a391cc9fdbc62c8f6a608bd5f982b3cbbd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f1662d9796e566722201eaf7b1671cad3f2b4c51b5df83929418602883cdee0"
    sha256 cellar: :any_skip_relocation, ventura:        "43fccb61b145175315db483891a6ae8913a251f717de3dbec26831815efae746"
    sha256 cellar: :any_skip_relocation, monterey:       "6b68e64c982a9ebb62f064ae94926a96246cfa1f442e25cfed99a8e6dcbf33c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021323f9ee51efe4e5feb73c23f6b4db960b1eda67e1be0c01e8415a3299a72a"
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