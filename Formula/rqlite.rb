class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.18.2.tar.gz"
  sha256 "e64c702bc8f44aa399c2e9117c4bc1b3b3e538053274f987fd121f18db55c34a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8964fab63be65a064ad1721eda30f4fb96e46c5fb0006f5195988f08ebcf1800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "845caa2325fc061295881402081f8c92d1f1d2f011ad06a85dc443be754a6cf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffb7baf821062337ebbd87c922e122c2e657da545eef741d3fccb4058240f147"
    sha256 cellar: :any_skip_relocation, ventura:        "286259afe1a10ea6940334ac2a5e0cf7397240ad57b9fad833fe3ac2bef1f364"
    sha256 cellar: :any_skip_relocation, monterey:       "9c3dfe999daf6207e9e3c480f26866ed80ce2037910468c37c0ea6a7e7e1a8ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "8609bbdf33a963fda92e35c02ee51437186b96855681fa09b5a9ff60928a7ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1011dd8289c4eec47f889bbaf9db278797d74458c5c88f74260e222e551b49fa"
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