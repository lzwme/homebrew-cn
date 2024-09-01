class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.29.4.tar.gz"
  sha256 "60c5d99e14ecdb6c527ee43f8e7a4f6f6df236d63eb7f22ce4bd1cefb0c5f918"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a4106377cbadf44f34af0b49424f89fbe509dc25c86ff0f5863f9b676407f7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d50e20c25d8f527967ac523dbc0deab0dc6a9a7837c7c51770289b5e1e12be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "011502ffdab1d0abec69997dcf3984b494d375fde97f8859d9489e1089b0dc95"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8f741d20f88fe28b907fa34297bb6839c7cbdb6d6995af9c86d05adce1cf5a"
    sha256 cellar: :any_skip_relocation, ventura:        "bd28f4526325d0f72f111f5958b2bc73566cffff7e724748ec13092799c34920"
    sha256 cellar: :any_skip_relocation, monterey:       "3e86715beadbb1feb68a8a958bfefa20236a174b342df8fad704268885a91b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f8c844fad842303bbe73aacf3943e0c1ae41f96e2610e5ba82006712e4fba27"
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