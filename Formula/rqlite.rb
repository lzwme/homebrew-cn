class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.14.3.tar.gz"
  sha256 "dbde6c161cb1d646717611815c077e460dd2476a90cf99ed530de0b6fa42aae9"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d68a95bc105cc77f3bf42c537d29ec2aece26a45a96ac9845b4f09b10e46b467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75c397fc854cd0ca16146c5f8312a110e6f46d7adf4950d60f69ec52ef251b9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c40456d56fd4885e26584ad74b64158a3d13a95bc7aaa10ad0287e05dfd60e"
    sha256 cellar: :any_skip_relocation, ventura:        "09028b1a6b1d30a2bf84e1e87bdf746b956806ef5c03039d44da4615c7cc1bee"
    sha256 cellar: :any_skip_relocation, monterey:       "6657ad7beb60a96cca10542acec167d554f007abdee5fabc520e46c366900464"
    sha256 cellar: :any_skip_relocation, big_sur:        "afa97ec28e9a42a9e0b0b4cc93e1bfe81b06f0af055ae7ceb7a33a0b0249f2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c9b4ec173c839abf107453e57b3bfb05701e39f6296613e62e8319a9c44ddc"
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