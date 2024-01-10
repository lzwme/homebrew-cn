class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.16.2.tar.gz"
  sha256 "a317e22eeeab78e7c2ffe3ba287a7e79c8556a2bb397d006f6647894d2b19a79"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d674ee34f87edba7e6464b3f4e3db11a54603094765f41460fdb9c8b13485816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23d40ad559bd6a4f36f30a20cce8b7bb2d4ac9ad4b75f46af47df314a3641757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1066539ced8466b0e46653a81ca5478f59c92af044d88a759c1543e6405a8be1"
    sha256 cellar: :any_skip_relocation, sonoma:         "706af6e3b97707a64d6f9604ec96011f65e0014a3246d22a28c3a6a169d08f0d"
    sha256 cellar: :any_skip_relocation, ventura:        "a27819a0c52b6459b7d978a1f3ddde6f8ca3b34516caf7c9e124b1d93ae84cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "51b4ef3849106277c3472ef0054d8640867d5b67270fcb574ecb514835749267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46304ca04edc8f243c8857c9c1fd7b52b0b3dc15cd4e086326fe30f94952a31"
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