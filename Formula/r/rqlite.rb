class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.33.0.tar.gz"
  sha256 "46e0157d9933b5361b5dcc666dcfb0312d2e3afaf27b6e648e761818cf9f8c66"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33c89966e8a760b022df36ed2b51bd66183b611ea8e94fd9d2de7a8196b9311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4db3503b060579b11028d2606f38a35a4b0f495a4a82ab55cd183667e8058b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6e8e5f80f369a33768defe7135a9474798e154dc5a102f5e7e09054ca3488de"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad1869cc8d408be5e3076dcedc7d5f2e6254375b518dbc913beb6930b042bda6"
    sha256 cellar: :any_skip_relocation, ventura:       "cb9e6e7c697afc894f34a2444eeba49df0d612cd9777c838dfdc05c7817d3362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f96d2dbb92467785a17301e66a473da44b43f67cfa1befc257978f8518678b"
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