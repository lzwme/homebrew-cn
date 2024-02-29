class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.22.1.tar.gz"
  sha256 "e03f331c04ee68cf3bddb99ab132b6d2e22e2b326817b9395e3ddece362374f6"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4117e454aa373fcd1e15ab36ad87d69493c7a0eed76afb12251f1e61cde0b81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b611eeb38b3e1b7346d40871d68cc4ad58e67297b51d52658bc474fcf5d36825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef9632024c4748dedd79536d4d4ef6f802d8f4e03e182056d8578b0f73b1168"
    sha256 cellar: :any_skip_relocation, sonoma:         "35109bd1cd31f6706abca63030806d8909c671eb7f8b3db9e295d0b5b4a066a4"
    sha256 cellar: :any_skip_relocation, ventura:        "8e8f856b5092612d263afc6828a8f3ad0c69d91885ea15c61005ef3847f7da7e"
    sha256 cellar: :any_skip_relocation, monterey:       "9a69268a1dcac0e19a79fd343ec28066b7968ccbc957250323e4c99e239cadf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fe62e1296164530d3b767fe2047a99dfeafc04319c702cb9865aa00e440089"
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