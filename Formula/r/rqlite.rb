class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.4.tar.gz"
  sha256 "25c2e20d9b5f4e09ae94f9fd6679eecfae42de0b305fe8ab2b39139bb427ec10"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "755fc77e2ff1641dc4a1f0d8326a3dd4bc1439bf351991214b4656320b6b6cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d38164ef037534406af46583ef52589871ecd09ece71cde3099f8048c44bcaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34f53cd9e90a7282224866df61279f26545659fba38263d1bb364126d4d2066f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b3a40ec28f75817fdb96d3620bf5b48ce7a1c7129d2eb8b116682b6964f5dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "48e33726004d5b6405fe9d1b3980544678035fe368aef299c88419945bd46d06"
    sha256 cellar: :any_skip_relocation, monterey:       "eb0798e26e51e64d6148778b68f394bbccf58e7f59e49dff89ddc09a127de4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dafa2f1f2366326a18f49546e074cf5414dc2e48b466b8224467c8167d023f2b"
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