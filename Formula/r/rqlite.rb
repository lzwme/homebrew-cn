class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.31.0.tar.gz"
  sha256 "430851158d15110df68cf0059102a98932193e225733fcdb32dbe151ca47c22c"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "475acd7a5604ab80c595759cb2b843dbdefe96ab4f2585a85f590b5dc6364e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8120783df71a7a80e58936e0560fb1d7b2bb2eda2208b194d17a29a28322750"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0d91b189f2a47a53fdd21d722ebd5ab8e20b555adc5611bb5b747b5370dae4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa33306440bd82cf64338c2147701774ad4062ce547f86771de2220e9cda18f0"
    sha256 cellar: :any_skip_relocation, ventura:       "7604d21d87d269624c6c790d8ae87c2f7abcd6b190fabd4927ed6832243077d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f0b251d93801eb612062d230238568a4253ef4b94e2eaea59af0ac544d3bfa8"
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