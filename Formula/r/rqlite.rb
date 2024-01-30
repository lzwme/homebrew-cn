class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.18.3.tar.gz"
  sha256 "8219796cfd65889fc055ca6659711c0dce292cb094556e62e2459a171356ccdb"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b1d119da591673e6d3a2f5436cfccd50360b1a3723c70046eb4b4eabf4a447d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bac4b5c32630c20c79f07b7a2198ff9b0a7f7e7a81d4de54f027b07b7e7aea29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "031604bbfb5eeed6053bd573e313f10b3ce157f3bc441636b6a9a2826bc6561e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb97cf69ea6241175131f698a889116e77df6150e4d87f8e0d3e2e25bff042dd"
    sha256 cellar: :any_skip_relocation, ventura:        "c459a40d5439230fcbc48c0b3d1174e8a1094d4912ff7579ecd8ec895ef8e425"
    sha256 cellar: :any_skip_relocation, monterey:       "7151289bc32d0c84cf4263e278414a780a29f03f8a39278cd0b2ffb7c0521ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87c55159fd0b19832eaaa017db463ffa419270cdcfa3a531c331d0c900f68c1"
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