class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.34.0.tar.gz"
  sha256 "8d318296a0110444a8f91c9d55d13cc9488786565f0c1aea56fafefe89a46f34"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25dff800d0631ea98251bc291d70fa43175822ef50711a48f685c4afff9904b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08dfb96459199e14805094b74f4a2717498033d08f3b665dbd69633733a8f59a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2487007e686ffbca3e73730cec7afe39362cea62876fef8dbf6a0ae152a44517"
    sha256 cellar: :any_skip_relocation, sonoma:        "43f73c36dce8563c75f9e65d61b1820b0c7edd24f129c68bf823d0c4c5d816ce"
    sha256 cellar: :any_skip_relocation, ventura:       "eb785ce17d916c72bda17e22ed623d2042cd1c20b01c075ae8aa51c67619347d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9e21732645f999fca724b40295184b3e0af1d580d6aacd5e009a7b5c673596"
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