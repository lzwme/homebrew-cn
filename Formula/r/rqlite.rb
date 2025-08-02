class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.43.0.tar.gz"
  sha256 "0ce0f810075c9460663489540753d941edd1bce490150418b334142e981cdc3e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68712ab85fe679d872be033b7f159d85f3e4af689ffd4f3e3f69202325fb2561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c1d70154f518ee42c9dc7ef04a7be316300b66d1ef50c5d3166948d4f91094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07af0b3ae546b67872126034c010322ae01d1592bce95b3b48f21661adf7f9df"
    sha256 cellar: :any_skip_relocation, sonoma:        "d588bed30965912246c29574f275ee50a65914d45d1cde06a9197bc042307b88"
    sha256 cellar: :any_skip_relocation, ventura:       "e723fc4fe3d6c7faa331ceb5a90e33cb2a801e7bca061ec55cf89d49d2f3b09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ce3c02f856162093264b3f62d11cb27cb5406477b83df2c856200c67a5630c"
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