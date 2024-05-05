class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.24.1.tar.gz"
  sha256 "a0ed442afc0e24ba9594726b1e99a89917de26133f3c42da2dd3b6cc5767d8df"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dac55260d5293cd28707cfb28b3d874e617daff9692d313d1edfb4127520f075"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb07691772a2bda854dfd1009b23fb591e4928d214bc72be7ca48d411f390e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e324025e3971d8af7cd52ba65e7a52b4addbcc377c0595be257ef2e6906a4efa"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d226f9ecd121fe363c604c1be3e47943d36137451ac57851882e508b70f1625"
    sha256 cellar: :any_skip_relocation, ventura:        "9cd83d7aac64d5f34aca8e62911e69ae7e958042689f6ebcff3c08d19d6389b4"
    sha256 cellar: :any_skip_relocation, monterey:       "d3fa4073529dd9a97073fbb9d92d5a879082ce5f8b33e5e45fad14547b230c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caecb14be5069dc027bc55e0d2d29f2007d27e141aac3b5a053be204eff12c8b"
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