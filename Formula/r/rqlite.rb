class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.29.2.tar.gz"
  sha256 "5119fee67a5ba67fc6e56c6139e67a482cff7f2b37a0b4058ac34b0c462e6229"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49874587b8f7c6225d819b4ed4cccfd4cd7132fc6b0decd3113c1cf448a98abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aeac50686a1545300ab782262a83573fc9770a313778af8e088a4c552a2fe33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b52400d90ce2413feb559f4d4d87275bbc7c5f4d94c4c75b1c9e7764962e3ca4"
    sha256 cellar: :any_skip_relocation, sonoma:         "953bb3a6ff65a5b50ea2faf23ecaf303e026205e96af7cf2a313bfa0e98d3e85"
    sha256 cellar: :any_skip_relocation, ventura:        "73eda82d43afd8dafb1436266df3554b7a22b6a8722e0367fc46d303c85e0b69"
    sha256 cellar: :any_skip_relocation, monterey:       "734643135aaa08e789697fccbe4fb81ec74ae32ed2c5f682d892c675760ec123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0282450008a2ea46eb06f77e09b8c490484771899729470fe3d516ea4d3a91f9"
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