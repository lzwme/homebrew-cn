class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.2.tar.gz"
  sha256 "88a0d70f4d98cc7bd23341a4b01855f300c8c6be5c67e8660c3e9c98159c885d"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f239dfa0e2ebe3ac71f5d3f8cc6308fd7b6c344d18bf8614c408e23199d51b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7076de020545106bcfc3a81c3ded6d25e22e7bbc33ec49c986f9fd4c2fd02d9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c444442b58b615c9c6d16b575b626a045a084ad2469f5633ddef536926e3de71"
    sha256 cellar: :any_skip_relocation, sonoma:        "6312633597916ec39bc32c9a7138372cbafa1dad4800741ffca9d1f70b8d98c1"
    sha256 cellar: :any_skip_relocation, ventura:       "4fb1f5275e550164d3c4bc44e8a72a7ed1109f0b2ac05603d444cf0737ce46f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e7303d80c0c1aa399a38b18ef6d1c8d6c7cc0c6b82deedcb955c163b4b35e0"
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

    (testpath"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end