class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.38.3.tar.gz"
  sha256 "d9b87b39440dec2b0e9a47a31c26539cb0cb1ed18e9be4035e6fa3dbb4ccd3fb"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "071c971b49fdb7cf506dd2c82af174d90a536b4ef05b4eabda6f2211a778eaac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48981ae17deb2a529e606d0828059f5ecaac4f7ee307cb683df1032e27d76977"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8245a1567b1cebec8974ec1ff1c380b5defc660371cf6dbc73289aa959534ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "4244df65844f273cbf46c30de54adbecbadcd134e300edb40f163ef9879813d8"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd39fba9277119765535f088f24aef009a44f3f936f7690b8cb6fd329ad1f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db20dd9f60f6762b2b11be3733d6f504336eeed8b53c1dd0ec3b36acb9c0d6fe"
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