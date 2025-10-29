class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.1.3.tar.gz"
  sha256 "d7b97c85c9db7ec2186b4bef92ab9daf55d5db041a120e7f1fae8e52c0c9fc4b"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba251cb39f88ca0af3a6813c223c3778de2cd0c9607206589d58c9e8495c45d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1754bab9a2831be80c4dc2bcbf1f417ab7b62f948fcf13c326556938a0af46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2dd6aaf1f5a58e9ce42d6acc0c5822606008b0cf815e5f5d237e45cfea622b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf82ffc5830d53fc50d0c4ed0768ef99ade247d7f342a78cb6bf5b61d909225e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b2aad7c9c2f0f4a1a11d1226d81a01f3bcc23b0a839b47480bf203d165814f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fc5a5a620b1369bfc938f741b4e4366bb84ca78a6de68e171a83e035c6ae33"
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