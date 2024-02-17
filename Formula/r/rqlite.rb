class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.20.2.tar.gz"
  sha256 "09bbc3c65e8e5109f56d8fede6e51d7a524a9ee227fb6c8e83bf1d03969293ae"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9edc7fb899139de72a4fafe4c09519e7b7d2f86b7629f329e0eb21e1d335dbed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b1d7d1daabb4835c228e8545ec831d920a46fb28b7fdc40ed2123905ae86e05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b8ecec85e0ec60f6a910d7611283dbf43d8055255b6c64f40b8dc85ad15aa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f2ac641ce1cd0e896b98036bb74b5a1668896b3140a801e29dc669993ccdb03"
    sha256 cellar: :any_skip_relocation, ventura:        "32cb4a549ccce8626ce05c3f8ffd46f38d2de9e646dd70addbe34b63cd4b4f9e"
    sha256 cellar: :any_skip_relocation, monterey:       "494abc4e584125d61fd1d9eef2b3f67ad36d6d022de1bafe33a327cc448c8552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e4225ba1c4ee7d70742023e6b85334ec6396f9a50a189fe50735d18a2e4c2b6"
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