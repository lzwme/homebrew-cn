class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/refs/tags/v8.0.3.tar.gz"
  sha256 "0cd83cc2ff53772f404caf47aab886e876abe2ca3ba5677151e81734152f7959"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c19df1414af4f7cf7cc6cf6075948447cf21461405ea3329f696c5f17a208c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae2cb141252986cdbaa83973f70a034eef1bdab22b6859a59cbf599c76ce482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941467a95246142caaa6c76e966b14216ad2ddf18a78f0ec3f3cb875e206ba40"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5f8646443b4a32b5590a322b13e18328aec83c57c245e6ed021027723dcd936"
    sha256 cellar: :any_skip_relocation, ventura:        "0fccf322d7a5ae1a0114d39fc79603a685043d4b406a72f2eafc7a3fc937ee1c"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb13be9cf67fa6b623c486f0bc70b36a78eb7d0b1de5bd66f4f20b1152c4ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2966c9772b3a79a2409ef069b31fbd55917f4d7c2b30750d650a266944d441b"
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