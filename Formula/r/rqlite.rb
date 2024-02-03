class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.7.tar.gz"
  sha256 "de89853a946a51b61251d22b5ef2b0d4fe256177e2e94e09405039f0340133c3"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4ec62904138b525d312d525e51b58f30e892a5f6d81185edd8088d3018e673b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "528a7882d8740f89ebbf42923b97794513cd14874e5d666b61d51646fb689ef6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e3d9aba79f45f94efe141dc1bba4be9eeb2d10aabc31e052ac4de7cd29a69f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f231904f89e4e2d8dcb0e87aec8d8fc9e415edaa5edbdb771ed95e6783c7031"
    sha256 cellar: :any_skip_relocation, ventura:        "8388cd6a2358f52c8f7473a066ccd4d0f8fe24c5e0f8498abf12b4253a4d0ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "b8ea3fd93d88995f5c8bbed3fad9a54ff77608a70c360d517fe53556d31fd2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c550df0e6825feee0d3a5c66df152a564797842a9430b43821d5568f5ace916a"
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