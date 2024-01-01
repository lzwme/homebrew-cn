class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.14.1.tar.gz"
  sha256 "03eef502cb3246f6863ec4590780e5c6b7d510a43fbb6e91d2c20103084b9613"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2d00e8aa16021cdedc5ff2ced034656ca9ec374873cff8c86a4238cb3bac12a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14f803a4c35bf27797dc5cbc57d04c417ab39e1b5d514b414493d2566318175a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bb34a12ddd04b52e6c1c65724e045b7ebc742f6258ef4bd1a0969d049776a36"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cbfb0a89c337d174c3928982c21172bee0c247c370ae02736f24fa962ec0561"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7a34341fd0a6ba068cab6fe6ecd303d4082c2088b9a28218d6a4de8d0368cf"
    sha256 cellar: :any_skip_relocation, monterey:       "aa473986ee4ae417df99830f035ea9b0ec85d406fdf62b4cfb19064222a032fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b18d91f59e75399ca1a3127fc2cb4802d37fac5106e617f7bff402fb70b3931"
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