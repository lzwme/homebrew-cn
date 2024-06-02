class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.24.10.tar.gz"
  sha256 "228511bc7cd2e3b1b40630b4f664c9b3ac27762a3cda77ae92859e694a29e66c"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4d538ece3131310445f9a60d4cede73b9096fdf3d689133146ec70e56c53ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9627c5d3f72fc724e26c30c38de284500581884e0193d66b14955a487060d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c34b2590bff783081eeaeeb0d587846e9f895f4d7f2b8e5ec4beea63a6f17f60"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cbac658b4a8350fb524a4a2146bfbb4ecbdd6f6dcb8e2679163905400f464f2"
    sha256 cellar: :any_skip_relocation, ventura:        "edecda1f36d93c75d34bcd9151c490b585eb20f2eaa0d8314733c867b726229c"
    sha256 cellar: :any_skip_relocation, monterey:       "b3f23b8b9021ed44cb52ccc666174d4e92f6182539d76e97f42855c5de97176c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5080398f83936ecdbbfbf51a3ea0bd056a43b9c1a3ac200be6baecca044ce929"
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