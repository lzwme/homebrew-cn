class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/refs/tags/v8.0.6.tar.gz"
  sha256 "17bc8b0b891d4eff6feaf09ede61e2ced0d9c95c42aae1ad1e916775272d6385"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41f91fae6cf448ae70de14574947c5ee2b3a9180e54e1e968e9cb975a271165f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d722db6702adb8becb8086748dc77c9929e1ae9055d7a5a64321ebf82b2141e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a41f2646417fbe5c9c38367cd3e4283368803c739b7b3f8032699ca64a7e862"
    sha256 cellar: :any_skip_relocation, sonoma:         "9793020db140ae9f51b3eb95b4cda6317ec6a9f224e086e198f82ea51d02fbdd"
    sha256 cellar: :any_skip_relocation, ventura:        "3385b4b2291c3538ae77e6670760b1d7196793c1813e9a6169af7edd52756930"
    sha256 cellar: :any_skip_relocation, monterey:       "9d71ab41f96c5667e669075d4057b97689a5f46f7a11df8bf1e8f1d83a6d5184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985b4bb394a8620d2107af35c67d033cbcec350d3485484675ed7ec721084e21"
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