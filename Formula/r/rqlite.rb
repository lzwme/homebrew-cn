class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.19.0.tar.gz"
  sha256 "4ebea9f05f0916d294c7d59c308e4ba9dbe2e684def3705f083599c554a52304"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "100ff9f440bd5bcaf2a2387621d73161faa78b77eea3813b19bd8023a40d3280"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dc6f46a997b930407812ba79599b37eba993c66f887bed4f3d3e4c4eec226cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "001bdc44456f232df30e957b2b3ddd1064e47ea64022c4f1bf1c94fa196bde46"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cbe162c88c27870f733cdbbd20e66a0b58ef6f25f4d9523e946bfd8e4230a58"
    sha256 cellar: :any_skip_relocation, ventura:        "e99b563ac52bd217d50afe43b8a3f6a1279e67015beb7e38729bcdc0cd5dc5b7"
    sha256 cellar: :any_skip_relocation, monterey:       "a30c343a71667894ff96e8858d351e9955fe80ae24d9e3138d205914e79f4d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f90066089c443c66550104abf16a306eff59fba5c7e22cad3a1ce53bacdde4"
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