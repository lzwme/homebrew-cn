class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.2.tar.gz"
  sha256 "5e77e278b9905c78e77bdf3a54e4d21af8b68e0041e4adaf3178b6aba98b2977"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40117901d2a6d100d8b21fa6543b82a2b9b11638e75ae836c0f9e3f0f335f2e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e06c43ee9c1a27f63ce55880907f6ec4664d32b3fb3a1a8d90dabad6f24b947"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e976c55e3e7a59e362d1d465b5b20bf82f7efbc27f4a1afa78e3a7e7cc5a0f9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c7569028375e06deb88a1ad79b944ad7b05f67eee0d243de32399e6682d63d5"
    sha256 cellar: :any_skip_relocation, ventura:        "63dcab524cd82da2cbe8a15a52585fc399468f9f6aa091ab4cfe477e6dfd3329"
    sha256 cellar: :any_skip_relocation, monterey:       "523035d276cab53dc95c1e714040142d7345eacf0cd8fb7ef5693e78782eed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a1fb291be536f6f99c9905dbc875a6dd4f370c487431acfc7f90af3e8df662"
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