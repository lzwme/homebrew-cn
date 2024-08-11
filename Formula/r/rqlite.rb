class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.28.0.tar.gz"
  sha256 "6f5d40d6a556d4158f6eea3e509ba89024edd2d1409ad46a0020739299475761"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fffc9649e46db35cef8432f7d0b690a72c5a93fbcc810a6c51a72f0d8ae40f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fce2c7000e818e2f9331ac19755bfb6693de9676462e13ae3ecda98cd34ccd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af2ce63f948e9b08c8a1c04e7622ac2563984a68515fb2da669b83b1eac7b64f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e54344e4cfc2cf00ebab49adc8c2624c7a77f747cb0fdabda4773e227930c2b"
    sha256 cellar: :any_skip_relocation, ventura:        "81cdd2cd96aeccd1a108a8710b00ec816c73ac3ed0d2cf8a81192296b2384b16"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0a5a31fa518d212566802933e96526323a0ac8864ebc5fb7857cc7a564c875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3df5a9f46e1af6d8852152d976c380b607af8f46dafefb49b33ab6b905733a"
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