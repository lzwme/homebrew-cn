class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.6.tar.gz"
  sha256 "6eeafdec35e621d441c09aca317d89ab08dd21b069c1a2ce8bc98e73a571c1ee"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "133015dc01fc4606deb50463e59c18e828a696eac2e0c0074bbc01fffc70bd56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96221a8b8461eae6a8ca76a74942067df819b01cddeb7833a363998214f870e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6bbd52bc4d39867f765acbb9075029dea0769ebfe4ffb5521f75bfa99abda6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f4ee4135de62b813f123a989dd1759536da4512626e9647b3aae756c19a2120"
    sha256 cellar: :any_skip_relocation, ventura:        "a53025f462734c233b1f75165f1a08bfe4fff6a664d25ba65c03d63a982523d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9bd6fc9015afedbdaf4134670a1952ec23ac5c80d0c83660cf96aadd666a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b957972a0942442d222beb34d103ab79002ebd5bb34520d59b9921a235818f"
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