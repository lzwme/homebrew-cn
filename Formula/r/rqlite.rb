class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "8fe0bdbe59ef5d68fa3770eaaa2e3496897c38b73c100e40b4b77961f3d66a7c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f4606deffd025dcfa310727c2f94c518313f50b2037e2387e80ddf8bb21a382"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "518e9f9af7ab65d5f97cad40d95d357c80a317d8cdaa7b4919e2af47df287530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d208ec1cac24a99a270f68f253cfaf1f7f26124e4f586b2a4f305dcaf1f28b81"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b1936d842ecd36d1d84306a010bb6fe42621137a449e2d31e0c0afd4d86c2d9"
    sha256 cellar: :any_skip_relocation, ventura:        "46a5c80ff4bcaefdf409db9b0aee9672ca939d6b3cfc9213a5deeb50bc4bf5a8"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc4bf1fe581a912f7bf4e9481722a241e5080f3bcf49e4a765f0f5a83b503ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9764643af5ccfdfac0089a3bb885f59f19450d52301dc424b488a282cb98bb0"
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