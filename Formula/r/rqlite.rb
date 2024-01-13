class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.4.tar.gz"
  sha256 "d170748cf35adb2a56729ec1c110ffb4579a26f32d031e59770cff5b73d796c8"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1333d27134178f8a51f72ed533480b3c406832872f4ea795bc2b534fe7d5c4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e6c79b522fa28596678f51f332921260a3b9e3b28283603b03725267c6e7167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dac07e0132c526ec8b27a3a40a088faada0fbcf0217fa3352751bb32642ef41"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f8f49b090920f18fc48603de1da4505347a666bc17f468ce8d0f7780bf4ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "8487b0879109f524b5db6fd6dc3d8efc18cd52ffe312a1d63cd9cddbfb33883f"
    sha256 cellar: :any_skip_relocation, monterey:       "241312da79dfd33efd9cc14a9e9bd07e518ffab6bd114641429dea37a0cbcd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f562b3ad9924859727e18efc1337041285d4706bf8b6e8bc455051860d96ce1"
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