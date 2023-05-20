class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.18.0.tar.gz"
  sha256 "3ce0275f8332f5dd3819b2a2c6e37d62dc0e43bbb703d672d00e6582594375c3"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4113c99d8078d300b1985c6e5cec7c3fbde8d3df697de16687d3c54bf04a902"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52028bffb1e1bb61e1fb0ae86dcec3dbb09f5ecf18f3b8da3566f664cc809d20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d39ea11076fc4e227e6317fb7fa4291d4b4562e11845c3cf8bd41e0dd4a27b12"
    sha256 cellar: :any_skip_relocation, ventura:        "5655107ec18018a4623b2c2afab7244c27ef3211409f55e3598cafd9e583a72f"
    sha256 cellar: :any_skip_relocation, monterey:       "678c6fcfa431c78edad1e29b69d544ae0aac0a4b2cf5e459b7372c69ce604177"
    sha256 cellar: :any_skip_relocation, big_sur:        "25674fb60ff233c52e5255c839d2b40a0c2cc5afc60349acabf8f6c06f0b7425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd4f8216e4410d433a8eaea8c8c7fad68a7de20656d076a7c5a7b1878ba2d9f"
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