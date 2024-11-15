class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.34.1.tar.gz"
  sha256 "7ab73a8bd93f48e8087feeac5e2d519048af20decbf7bd540422167e5e6a3b0b"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4607ed94c99e1853706c556abb69e1573d073aab9bf87dc2dac2a9637bffcc7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a60a5c34b2fd91ddf24024cfdab8ed072309011bf783a1f7d997f6cf1c90d21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c4a6eec379cad74ecb6616ee24b677d97816da0ea80b2307295aceee5dfc5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3a27e03abaf16fb73bd90ff0e7f47d0f824c9637d706a736c4700a74f63577f"
    sha256 cellar: :any_skip_relocation, ventura:       "1e906a16b01f6f41ae11b7ef00f97af1eb0d8c5a05fc66d021db77fa3382d8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c57eacf2488a4c6ac12328dc82f852448f5d464300eff4e1c2e89f1e1eb7722"
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