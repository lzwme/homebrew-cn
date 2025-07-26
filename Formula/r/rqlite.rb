class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.42.0.tar.gz"
  sha256 "75c09bebd165dc78a329968b2eed84de86e772780458898ef325f87619e7da5a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ddec4ba9be9d9c2701f60e33964be357091c4dbbfdf11c186d908d5bd85cd6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2058d61bc58e74bda444b61c719e00fd1faf3f314900fb990bd9c9f062335b34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "554550d4314710b1f064d9ab24f7ba69711c8cbc04ba190cbaae7da70b42a87d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a26f3b02660fb7d30849f6b33f8603e1b0156b3b0319d61d5ebd7d4df0f295d"
    sha256 cellar: :any_skip_relocation, ventura:       "dd120af7e8b905d8c2fa4c67e3957a1f181f9dbef5ac79deaf84dc674122b6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e96b03b29ecefeea526f8a9004c0015cd28b2d68bae5caf8328d9328ecd1b2"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end