class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/refs/tags/v8.0.2.tar.gz"
  sha256 "6df285053943f09ec47a3b936b33651ea9fde6f31e9616313a65999d86b0ce5f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "854b69485aaace9034f8eab1bd70a6ede255b4d7804212d95610821d19f5f757"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad257f94e6ce98bb2d408c364a8f0df290095d8ce167be069822e2a1c806ac5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d34675071f1d334eceb910c785d982061dc33d9eba82020d722983324dfc6e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e5b565167daaad8e5988eb7793627a012f4bd421f8846465ae387afbeb24e9b"
    sha256 cellar: :any_skip_relocation, ventura:        "31dddacca60d63bac1a529f2123d109fdf10ba858d80e01950e5a8ab778fa57a"
    sha256 cellar: :any_skip_relocation, monterey:       "6be3fcf12419c945b208253b189cc67584f1f1c410edf6d8be0aadba50a55574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ee87cc43d949b548b2c39afb5b5f1f7b36125aeae8824e7ca8db56f35a58aba"
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