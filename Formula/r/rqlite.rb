class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.2.tar.gz"
  sha256 "d1be942875379d60fa77409f93d7aba13a8cec6a82537517c785fb7d644bf4cc"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d02032f81f1168a75dd5f23b64faedd2a49264fb5eefa55d07fed77b8537f237"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c49cdfd7daa196dd660866bd74f380971a5bd756c62b08bbc1d03033f473bcca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d1eea156b15ea78daf937cbcfb60c04ff7871adac9e4abdc025de7c6b18cb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5795b72c04c003f3380db1fbd98f2cb643494830b6f063893064014d1660777"
    sha256 cellar: :any_skip_relocation, ventura:        "a110c4608acae1665584b9de6a605aac84adfdb37966d08962345170d90695f5"
    sha256 cellar: :any_skip_relocation, monterey:       "4823c8bcc9edbecefbe81e851c23ccb970d707e7e3039b1677370423589b04e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74138bceda02b3ae3d49a3e5edb030ac43dd69c49ebf23eacc6f5a56e44a92c8"
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