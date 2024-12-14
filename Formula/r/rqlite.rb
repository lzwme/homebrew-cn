class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.36.0.tar.gz"
  sha256 "a33382d8b616cf06553fb462473867dfb06ac63e5b44bd4a74e1c233f07a025b"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572839495d2c59a308ba651e9ee8edca3e661ec05f7d5c14e91040c38c1fb3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96de88add3d7b02242a718d3db7cf267ddaa0f30ad3f457bf878c9fc0be6cac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96980fe70d6a1a47b4eb8fc60e22c24074ea5fb38aa36194dde280917a3decb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a91613c51de0fe8088c41d9e8a59f72aff2f0ae6c6354d298183fd5dcfe7df"
    sha256 cellar: :any_skip_relocation, ventura:       "877153c4f261df5818b885cacb15f1da44eaeaea3edd52953aee5b123d812c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5494621bf9bb03266c1cc363be3d3f98d98376c9336dc628b5020a55bdb12fe2"
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

    (testpath"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end