class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.30.0.tar.gz"
  sha256 "e783897d82eb710e380905bbc38e2baf9d89ff5329f61d2e67912f96c7f5f2fe"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "999b7cc734b6df8abf8fa86a57cc359351c2e9613ca7db6a29de4b4a78713d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97294d598dea9e4d6724ed1f334a96d7b7954cca7cddf3bf0e450daaf5e1f6f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7229716cf07ecc1f3cd7250c85c9b2f9ccb97b4cc82f9096ec7f2b3866265f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a407fb7e18c39a539a3ff76d57142640416e23ff405d313276b8042fa37a1fb8"
    sha256 cellar: :any_skip_relocation, ventura:        "0fb956fb744fc5f59d48b50c75ea543dc4792c3f45526191a9c9afc0cd94dd16"
    sha256 cellar: :any_skip_relocation, monterey:       "9a8fb3843aff2e0fe6781340fe00af197a1ca95332d50378880858815ca427e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860a3d55ed4b914919642a2f5964141d92063a839b77b56187b67076fcdfe8a3"
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