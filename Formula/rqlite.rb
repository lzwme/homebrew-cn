class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.15.1.tar.gz"
  sha256 "846c166554fa3f940db7c26ccc2efe3a4c3ef97d6d821549a01e2b07a2bc77f2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009bacfcafd27e1af50f07c5b7563fef9f97e8dc8faaa8d7becc94ac244d9152"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93a6d6bc18125c1cd8c8c7d2c7e76b49e1f4e2e38ceb62f06a633a98a67dacff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "508d2cd418d97032ba52082388a57494fcd47669ec0de0aadad3484a75e83bb9"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe82d0af1cefed219ec637ebccb044d940e7f3b74677aee49ba4a9f0330c9c8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8717a591753e4ef468c4d5b98df46d3d62d728db3c9d1fc8f9d880d068e8e3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e60a081aeb6c7e749b83fb77fd52ee99353a471d2a0c54d1958a60bb8fe11f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068638d033385bd167d7fdea4df50b5c095ef442bf5e6c0f95c472a265895a82"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end