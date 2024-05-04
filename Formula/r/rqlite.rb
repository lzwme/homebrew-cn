class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.24.0.tar.gz"
  sha256 "e9280cf375fe8039f09575950a9683c24a6aa5769e51113ba97fb5fbe9c80f14"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "410f777706dd50b6bd4b2e5aa79027093f85ab9f710c09f7f8b7c05390a670d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d4b4de91dc157a7bb9a342f071217144f64e82908d999007adacae7161be493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09890973c59b58fb24a0fbb72b93ef7076361c2003329063a2496769105e6a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f66827d84d484890c1de0693712552bf22fd2277eac2a0720effc2c470b7388"
    sha256 cellar: :any_skip_relocation, ventura:        "d10dfc25143a6a05f5c42c258f249a96bc471090ce4305ee1b75d0a62ca6eec1"
    sha256 cellar: :any_skip_relocation, monterey:       "054bfd3ff2c45de0dd9e013cd0dc2d87e302b96ca49c01be57971adadc2cc6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb64bc6989f33b983d350b5d1e62b345ad67a718a86406113b7f7e343701b79"
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