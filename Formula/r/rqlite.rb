class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.40.0.tar.gz"
  sha256 "fce0b4b7f2ad9cf82a635c2df3729fa3fe185b77f9cc88088ccfb12031ce3452"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2669278ebe112dd1d7c8faf8595dfdd06b388b14a95f940249c0d39ed03e9bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "454e3de40fa391557447580cba51ff14c67a27fa41261ede83ddc68d4b1569e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43fc588e13dc050ebca29ecba7363bcf66d2e23ac33ba304e6c341832ab93bd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c75779d38abea871606c5d0219bdedb718fdf781742ee8803b24b7563a0ff8b"
    sha256 cellar: :any_skip_relocation, ventura:       "b0cb379ab48ef4e422cc56abfaafc0e6325c8d0691afaf9fb73b39b914ea2dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac23b7f0d1727edba085fb304520df3e6165e28c3bc54055cf4cea64ab50d3c"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end