class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.30.4.tar.gz"
  sha256 "1e603eb6288bb14a01756c17e11da995bf45a2310d80d14b222875a28123249b"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "115e54b07d5d92c62d59974d024f14d76566f8dd722de7a85ec662da6621beac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7a970848e17fd39845b7a0383d8ed3309ca361ab7548c89d212bcdead445f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "691a6b992b74152819d929daa319d516673833ad243f3cca9b820ae0b380dcc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c934b82a50dd53048d35ac5489a1f8e86e3302466c3b3d9036ca301943eba96"
    sha256 cellar: :any_skip_relocation, ventura:       "8de74458913494a8a7bf9e6dcb512e77d66874ff4ec7219d3fa2e4168eb32b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355e52647e32ee7b5e3e80e65a0826c688bdb899d70194151660b119f9a9feb0"
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