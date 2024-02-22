class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.21.0.tar.gz"
  sha256 "e5bb04c4631f75b258a4b731a367c9a2a88c3c71ef54addd75610e4bae34bec2"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "900755ed3175f892470011b8d991461d119db23a6cfa33f23035c3edda157dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e41d4e1b7b7c46b732f14006aac0b38a52a95115f94a2f04a0d4ea2398a679e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2507090b244f01b468abed4899052bc238d21a74f28379c248a6997218ac90fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a30c2420796343e362f7b3bd7435c6d120dda21b7c62d1c871723a43cbc6bbd8"
    sha256 cellar: :any_skip_relocation, ventura:        "919d3000d8bbbc14958b40d31a842d1088d920c354e141e91f00152b029d7619"
    sha256 cellar: :any_skip_relocation, monterey:       "0c9f192390e9ec51e464867af87d2b5d83cb8b7012636664a5386fb3dce55b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe9e599a73d0947300a7c85221b4d69e2cb5e8ed157523fa04191921fc868eb"
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