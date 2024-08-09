class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.9.tar.gz"
  sha256 "24ba488bd1c1ec64971c518e1b3e346f19db9dd32965293a039dcc9af21645c4"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35995a7ff0d797404786b4bdd92ab738129facf3ed5d57a2556d9b377eaa4322"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f77d29a163f17fe011f2788bc6832ad7da26da261e300295b7759a97897f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "750b983807b4f27f11ae139ecdb7966f36f60d4f29db280e4bb6f5b9c811a3d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ea70fbf71739173022d6160791b31976153243d32bc9aaefea76f14f6dd489c"
    sha256 cellar: :any_skip_relocation, ventura:        "6eee675ca641988c6157a933e196509be96c64477c9fe11a5496bb967318bcde"
    sha256 cellar: :any_skip_relocation, monterey:       "548fc019f05d4d587af51ac44c129934a8cbb9290b38a6ea5c5bb7c3ddc513f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9929ed4e1825ca9ad7d98f59de1a96d52d3a8ab771c2c9922be48c4964d25197"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bincmd, ".cmd#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end