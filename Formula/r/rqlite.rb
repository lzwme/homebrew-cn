class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.8.tar.gz"
  sha256 "1ddc9c78b388321d4a2dc014ef7a31f591144fb16368864d53eeb527bb84d8cc"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a0c2252cd3200cc7d3e01718e65bde7b2f1bbcfd8c8121e5e62bbb18611edab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58370bfcd963b94485bf45f593b97ed9cdbf12be73708ee24a93d9fe7488ffcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "004f252d75d1cf795addae753e3cb8db012c7ad74380e034671be273cedac416"
    sha256 cellar: :any_skip_relocation, sonoma:         "293d40aa3435d8ac06c03ff3108114de787176546bd6dfaa7861de52bc17acbe"
    sha256 cellar: :any_skip_relocation, ventura:        "7d5e8fda00cada4b0e93a6a12cfd29318d191f171db93a1155a181cb7e3e54b5"
    sha256 cellar: :any_skip_relocation, monterey:       "8f34d8c3badada2736fe496fdff5ca6e5c7667b3090664675fdf097431eafdbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6614400c06afdb4c9ba295ffd287851204fa0088130a7dacf0f47c0dd0e2186a"
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