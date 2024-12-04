class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.34.3.tar.gz"
  sha256 "6c4c69f426625de80eecfc4d3b7c661183abefedc15f14f4971095823e71e160"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bb8fbcff7fadad2038ffc62ff5215b7fab5654287d3e726ab75ea25a5d81432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "109ac9811b14c75044ee6e1203d8581dbf7750ac3f6645f8a153b899b889bc16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c15058652156918b9b1e6d038dcd73525a191b50d80fc9f4de6115dc1282c713"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee19b9c725d8434c5897139ac78e883fbcb160e8fbe11b3901679f3ecbf79534"
    sha256 cellar: :any_skip_relocation, ventura:       "002cb210ae8264bf1fef9231be567fd9bfecd8a77f3e7835f9985d384eba11a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0595d3202a54a47e0a9269fc80b7ab47da0571c75c2a36794db2ba5a18d9057e"
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