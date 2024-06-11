class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.25.1.tar.gz"
  sha256 "cd2a6a594184a102a8e98ee2ef83177525119a45b9f7d25e477f48263e9008cc"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd443044e4683da4fd3e53da58d208ac7385ac7c11570a989e2207dc5d6adfc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4d50a50baef1b7922eed6e005f5e62be6690b00d34c9d0fa316e4a023ec9fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c983f2e253d344efc4db6a9c75740732bbb3f2337210e1a9d8ab8c8cc3aaf91"
    sha256 cellar: :any_skip_relocation, sonoma:         "cffae013f742ec45cd0ac14786dae4f191c5401ff0bae7118dd16fb0d176de82"
    sha256 cellar: :any_skip_relocation, ventura:        "c77da96afee3446ef76e238715a380d1e5bfe93f88b827ecd41aad08d9227c36"
    sha256 cellar: :any_skip_relocation, monterey:       "72670e4d0a71ef07e3220b6c8ff73477c7b9c1064f0d916172d7b83489451e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6924df110ddcf6aff0e49ef26b7e99e2b04c531fe6e30bda16b91fdb42c392"
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