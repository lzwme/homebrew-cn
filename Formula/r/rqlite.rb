class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.15.0.tar.gz"
  sha256 "7dbcc873af4493899b723de27865ae5ce1a8e74c2599fd2c8fa8c364c1607bc4"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1443e0fc632f5f9825b48fce50d97154ecb8be94be1f860f0b595bdb7a20efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd5d61584e33ea3a8dd9be547dd83cc3f7ddb29aa01b44784e85b56bf47a85f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2eaed450ad18c31ed15c8289d2dd2d651e7a8a5e416fb9a72259657f91013b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "38f351e7b6f175b727011c9540cf331b00e6246877d93d191c4566188102240e"
    sha256 cellar: :any_skip_relocation, ventura:        "78a870148ab511509d805709d1c294e0eec700da92c3cbdc2b5287d13cf1ae61"
    sha256 cellar: :any_skip_relocation, monterey:       "01e8e53f378cf705eda94539139e31a8fdcbf22407b083370bb186380c853afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef99837101de5d9bde3f06c5c9598f10b145369148e6db536c211dd49bbdf30"
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