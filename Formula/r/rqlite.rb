class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.8.tar.gz"
  sha256 "4182ea6432bd1403aec23ba4d895da72aef809d79e12343d781a19e8bcacb407"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "132dd681adc9d35cedb29158dd41d7fe0ed6667ef78617fc7c6bc6f158860409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f30524df0b48839ec1860181dce4c61144293652739efa1bca9a0d98e39d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e3c03df393579a407142f5264186cde6a66c27dbf7f1c8177e7bb93be3a67c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebee33b8a05b3d11eed34edeb50a51ddd50689c2b8fd09dd2ced0b5db6f2cc6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430abcc30165ef04e64e7ffd4168ceb51b57e9dcd247c5f46fc23d0ba2e3be32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8cc373c19bcec0055d5f7ad35985af8acc815c399cd7c257b4183271d5b95cf"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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