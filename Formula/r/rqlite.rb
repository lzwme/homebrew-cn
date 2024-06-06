class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.24.11.tar.gz"
  sha256 "94cc3fe1a0a38276969c00c09e072a44d99cee9601275724ed50a5c4d3c41ef0"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d48368c42dc81f924182a8c01d4ca7a2b0dd381573cb1d2741abd4f8e4cdba58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "579ab80ca8c702f72e47f0f96bfaf029d701777464688ef2f20280084675bdd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df84221730ba72bbe857e97436cbb51264c9cf54a333a931b7a5dd0d65e598a"
    sha256 cellar: :any_skip_relocation, sonoma:         "656d619305e66e7864919dcff76cf43cbb82642fcde6b20e61f6aca469f839c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e9668563f1a29d11b76b961f0751fd13c3d1705b84a646635b144c74713775e6"
    sha256 cellar: :any_skip_relocation, monterey:       "aab104bbf8388f6a54d3257f05ae040cd160056f4ed5df10f0e6b3aee46922a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d889fbd903bdd8949eed70cece3db4e0f96100dc130818f7c037fa787d4ab183"
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