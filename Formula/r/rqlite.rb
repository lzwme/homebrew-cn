class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.0.tar.gz"
  sha256 "7ca61f8cdb71eaec806714cbc75dc8429271c26334663820a81cc0c77190cd28"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5ca6baef4a4a78c09eb0326c70f8824b76dc59991685dcff20815bac50466bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8c04e2e986380d5e5324c6b4d203f99743087a356c32b696b4abff2080b737b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a37cfdd602b07f05a7ee4192e0634f90938f516b586d48dbe92cba579a4b18"
    sha256 cellar: :any_skip_relocation, sonoma:         "773f22a2d27c4caeea27b055dd5b79671b5e4355780deecf97bc3cf9cf8def17"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd81fb6c9857cd89442498eb019a344567596f3e22843ebbc9bbc298d775d36"
    sha256 cellar: :any_skip_relocation, monterey:       "48cc4e73a36787ee02ffde4c0ce0fd2b125a4749255d09cfbfd30e54b7077c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eb9fb29ec131471f059576164c605d4b643b8e7e6b4679fecd55ae4fcb93c29"
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