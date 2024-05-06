class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.24.2.tar.gz"
  sha256 "2a6d73aa3afed4fcd2758cbaa1206a1e0ab0167d808c0c95103330e4785fcab3"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12ab34bc526ea5e2cad3a98f118a9e2afe799df972b3993fe8c05d689b6aa2cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ed277f81d32c298b18aee230266faa9e133879c7bc9195b129d08a62730110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4bdc8b80975e959079eb37eba1c8d8629b738e287c6893ac8569c3fc069b1e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b16334ca939e4cac744ede4fa3acf758b5663f86181058256e1656a77d0f2c5"
    sha256 cellar: :any_skip_relocation, ventura:        "e8d2a573ad8054c8b926cebdf51e0ae756b4ceaddec200699c219cb0acf3146c"
    sha256 cellar: :any_skip_relocation, monterey:       "4159ba93457345d2f226ded3c2899e1d25a77b62ad3aa0605cae927f106f0ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9160f3b5a2db281c44e03e8f26408515578ac2585f217a8e399a25edc1b46b"
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