class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.21.0.tar.gz"
  sha256 "117609485c7160026134da425251f5188fe05f8dce80279e6fb3a13d938b7147"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29dd820e0d6da2fda66cdfa309dab1b16347bff4fefd869ee9c830af2f5c9f34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fea77321125561baa7f707af234a38479a98a7ec8904614c38ebfb0d46be7a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f62f71c2a393c9db27ee7eb41c39c6cccb3f93acbbd229f44725fc2bfec6201"
    sha256 cellar: :any_skip_relocation, ventura:        "2877c2828f0f88a24463e08d53a27b74d01dba3ae00167fedb2765f7a2e4b747"
    sha256 cellar: :any_skip_relocation, monterey:       "557af138918011400d4755ac8cbf23a6db4dcbd1118abdb7412ba4fde08ce5fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca1639c2cfe94a1104cbe8bbd90331689e54d0ccc362c2d2584521fc21698bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aa2caf714020b564bcd3ba54f856bda551694331b25e7120607aab50a7cc2c2"
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