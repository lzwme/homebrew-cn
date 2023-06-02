class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.20.0.tar.gz"
  sha256 "49a0f59da91239470cc6256a8a65c606391cda6889a9effc12d6bc4a7fa98aa3"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93ead991999de1bd40fcbf33fc809742fec9d1f7e8535b6ea9bda9051182fbc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04bc7cf22c70b95aef8fed205a611eeaf2d25b61754336694ffd736733357890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07e70c43a233378b4cfb86ce015a423c4b75533169a55f6dc9bde306359dbd04"
    sha256 cellar: :any_skip_relocation, ventura:        "ab4cf0be859d08276bc8aa51c8300624527b080e6d1e9d7afd2d456bf02fd6a5"
    sha256 cellar: :any_skip_relocation, monterey:       "0762ab285c790f564114dfb5283a202abd153ff7abd838288ed6e73b213b812d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b6b3383146b27663dcad82718d7c959c9c8c0cf80d5438cc1f967efa9341cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d2aae686da2d78200508884a69784e4dd95c408527f0d91dbc89849dff6ccd"
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