class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.7.tar.gz"
  sha256 "3654e2d06cb10b41e3437db33d930cf01b877f405c7711e88bce870bc66a9220"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e8f735f850b16b979c00828a6cbb402fb6a931806deb2405d8eeaff92677cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a2fdfced08620c1d3b09d5c21d3c0f0ba5cbd9a55bc59970d0c9d4c2b787d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3336f32fdb3bc9538c5a6043316a2619cbffe427519174787e7ab74db9b59588"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d3ecb8c3f849ccd0b38d59ad107a37b1cfcc9d0e9536ccbcb5661c6dee76f5"
    sha256 cellar: :any_skip_relocation, ventura:        "fae0031739a1b480dd1cb3dea4731f03df9e0c9c6b832a437a4c03c4d4e95c16"
    sha256 cellar: :any_skip_relocation, monterey:       "7a4e6d872cc67dd99181aa9db3f2ff26fc92baed18e4a238d701d8c1f50f0816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6386338a09187adcde7ca88f5af04c451ea9296f4c59f5d448649a14474e07f7"
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