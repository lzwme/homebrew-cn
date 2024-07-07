class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.6.tar.gz"
  sha256 "441e4fb97ff095affa6d97501a653713867b514047bb594f771d4f41333db16c"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "823a72ec764e4338d9091a9289974f85bb05319ca794438043a273c7bad40222"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc391a6e3c42e0db5b4c7ae47ac595d63b855c634e96c57b5622ec71b87226c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aa9385e50dd8dadd93422d4e742daade0f85cb48cd89255ab7177cde10405a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "663c477917dd8f0e815cf41a615aee4ef5d36bd13a651766b8a271437680dfeb"
    sha256 cellar: :any_skip_relocation, ventura:        "2438e8986dc984152dc1665ca6176387242e72bbe2161d3965cb34ced2bb64c2"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3007356e28c338bd3a169db1cac8628705e76d83fe2dedb254bbc0295cc6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66ae7173f995fd3894ce6db45fe29b3fea4de6231b3ad61f3713079208f40fe7"
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