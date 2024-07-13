class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.7.tar.gz"
  sha256 "7a30577a3f016ee60405bf60e74d8d9b0ed199d1ce83e4d792f986eab5c1546a"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a56bc8e639437422c0a87c1160fb12291dfc6870190f40a130da363d16bc03f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caf62eabf58048d5ab49282013919e6da12e69b5838fc4c37c53724754efb33e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fd5bb1f737003ce856b9be844b366188bbe1c75462b3a261d1b97e3f9cde301"
    sha256 cellar: :any_skip_relocation, sonoma:         "91e22e60f7177d401be23259d7277137a278c7e6a7c7fa88b98b8c28c64d9ec0"
    sha256 cellar: :any_skip_relocation, ventura:        "bf1dd6d92e97cd65957c5fc69548dfeabeab7a9f895d051b348a42bfe2f16919"
    sha256 cellar: :any_skip_relocation, monterey:       "75e3821792d45f2f1b6bcb0fcdb6b8c3f9bf66a6a0b736ab89752a526eb34c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ae05b899a2c3c01005dfc38286dfe75111b3f1e650485b4617f80ab48948b3"
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