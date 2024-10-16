class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.32.2.tar.gz"
  sha256 "8099c7017d51824135cfdca5e0a7994b9da61bf68187161df6574c6073efe17e"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee89e12fcaaa6c21d234bead376003365d342fff3487b1383d5512b5d3f894d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "778a1986a8dd401efef84e8cf66b327573718d20f561c5b9ac6b184ad1563875"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a419ab9b61c71c593412d4047b026be5af879bbf6b5e965882fd0935068b7aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a076c27d8bcafa3e4ce445eeb9dc9516ce7ef830fd497e2d1c610685728f44c"
    sha256 cellar: :any_skip_relocation, ventura:       "c4332269f7a9f64a4bb892fac0b401aa01345961333ca1d58323e8528cc0c28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69882e483b41fbc5de15fd47266be4c22cf6c2223c95aca71e425368a2e530b9"
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