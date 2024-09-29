class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.31.2.tar.gz"
  sha256 "597fc8f787401273dd65b014245b1005d93d0b72648e185d92c7c21ad9558016"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3bdb3b0ea507da3711798fdb092259c89efa37b025a619532b1f6acb25217d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869125f12f6f1dbf9ca2adcf8dc7603270e625efa9f53296b4e03f093da7e9e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29bec617aeefd8bf065e27f2ba92eb57eba100dde775e71274b367c6c0107b1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a800e89582e7d504a7688e31087f4c48e86e50e7644beace7f1a186179fe0f"
    sha256 cellar: :any_skip_relocation, ventura:       "51fa5e872074e52cdb6534d2d2402bffa73ad064289a40465549480eafbfb21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c26c6bb38831955f2e87174fa0070e544e3129894d66f50b61921013fecc867"
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