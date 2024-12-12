class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.35.0.tar.gz"
  sha256 "b393b4469d3eb81d166b51832d56d56d14db8a015c648c9668ea0d171b808d72"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b269aca0c57f5af97289596bdce3ab1e0036c75047d6d17b8e70ca677326da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70cb4167090481c0b9faf35a74f129f7ef3673420233690615a2568779a76db1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "847ca8eb7116e8816dd1c21503c386f2708a823d3c82d8fb95a2a2ae87979a8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "97864b08e9ad7a2cda0798f527e8cfd6648fcb945a35960d59d9c513ca349d2e"
    sha256 cellar: :any_skip_relocation, ventura:       "cd1777b10099effa718c5106ecbae06a2c362bc2b9ab1712849b52a80ac99120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "194537136b2fdd8eafd2d449e76affd1cb9f3081dc112ef1ded5cbab8d138188"
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