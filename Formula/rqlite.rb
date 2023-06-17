class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.20.6.tar.gz"
  sha256 "7af2b463bf36e67bb598ea63137c8210e0f5590aceda10fd6f6990eb8423e70f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3170338ad469bb2f99dd5a8aefc106098379b6693e4bb6e885026e17c7ea129d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3790b1d7c9b677c7a9b99c0e768e17cd7b72797b2bd7f2b06567da29973434e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df65e6aa92ecb2a456ad96662233f212d1ce6837053842df218905fbb176b0eb"
    sha256 cellar: :any_skip_relocation, ventura:        "e3ccd6fd788f369f4c606b8da5661e4964f6abcc9e1cd926794be3fe3e30f6c1"
    sha256 cellar: :any_skip_relocation, monterey:       "e70e268e5e862d98c1e191fc63ceefcf2e12d64eb7b39dc110b81c93ef91b78e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d9130efc4ca1f80aecca3b9a6827cd5fe7f288b2ed8769265b2d3a0e6a23546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7462142d5103463822406bfbb064f64b68db9ac0c67fd28c32df76fe930a08f"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end