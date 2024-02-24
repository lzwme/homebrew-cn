class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.21.2.tar.gz"
  sha256 "61bce442a96e2f666277edcde9fef43e0f4f25e6f35e411f4d1aae052aa3641d"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42f242228d154640afcc122fbbc66a8fe43b115a97ee4ea0354282f49917c396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10272e6a4535501f2e199673efbd6d335536d938c242e52c210e798ee10740fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cea9ce6b71341aa04ebe79dd8364441502e94cdfc35ac23bafadca0226e9578"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fba23678230dfc92d3fba29c3dac1322090f91612a7d9f175d8a383a8a084ae"
    sha256 cellar: :any_skip_relocation, ventura:        "cd71fe08f8b744ba794d38651b72656dfa232f70782b7004efb48a33effa1e48"
    sha256 cellar: :any_skip_relocation, monterey:       "54f86a199eb74d97220fa08dad582d84c2cb1bcfdd8c0dfa11610787903743bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ca570e8df42a83e738d896a33a2b80bc88ede6c71ad359c5052647d8b7f96d6"
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