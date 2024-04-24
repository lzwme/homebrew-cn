class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.23.3.tar.gz"
  sha256 "5df9885dadb3f8896923a2427b4611d832833074b19d7c284354ba11a0151af2"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6734b281a82c90e4e8ada952492b06dae81acf0f29c6c5728e7cc7eba33b777f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ce4bf4fe384486041f6cf3d4449004e2d30fdec708c0ba27739ad6facca6ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead6fb4b13f522dfefba0262a508cb2236f65b12fa5b3f1a90b402dd86a8b789"
    sha256 cellar: :any_skip_relocation, sonoma:         "239ce648fd742d36a5773a0e6747ec6104e722cfa0699dd90de569ec288f5933"
    sha256 cellar: :any_skip_relocation, ventura:        "496bc4f9ff26583c11b4dcee0dfe8c8c33bc0969f6c9efb0962137fc7472f942"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef0ac495f50ba27ec06eded930bbab089e5b7ea010182d2e1cf3ed1daba5c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7aa0230b702d8ff7a0cd8c0cc30bd828d5ffb0aed860d7943d445baced0110a"
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