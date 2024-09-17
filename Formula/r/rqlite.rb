class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.30.3.tar.gz"
  sha256 "a669de66043dc053f8fa00de0c82fb4797bb7dd75eaa3998e43d3ec3afd8b9b7"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467f8913aa434c6353cbc206ddd4ac1e91b02339e1b37530f142700b03a3f405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b07b54d971b86e23f0ada0eecaef27730298bb530cde4b195b7b82feb4e4f657"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01ae1951bffabf75635553f5b91b64616668d5babeb9399bdd4e08a04d65742d"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b768cade52da2502c456214c6938ea4a047d45f327bc6c904cd9ee96b8cce4"
    sha256 cellar: :any_skip_relocation, ventura:       "8bd780aa7bdb611abd9e60252ff938952d4a41fbdd871c9c66e4e8363a3535ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a4d3ecfb3078017b75814aa82e5a2c160e2a801e6e9df43af7b2ad8fd89f74"
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