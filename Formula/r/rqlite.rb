class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.2.tar.gz"
  sha256 "f63a76314b8cc57b236c65da082e9fb6fe7c20fc2b7d8e1ff4ee116bee1aa5a9"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4695019d2107a4a0d0c0653bc9e262f64ff6a03bb7b3cf3f8422f1ad304b8f56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ea4615cc122d39aa306928770637a3144b5351b9fab3b71e4ea4c10d4cc815a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b082398207ca8c72afd0030edac1ef1bdc743d0e376edae57c4db0b2d68ec381"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b652646876ba22100408e06db53d73138c721319d19000d66098b5ee19ffdd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a86d12d5b3b523e1d63ea7895efcafde0fc9a2a57d5cf1ef77c6925f376727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf767d177ee6999053e1cc7516cf8021b2ef31920534d8dc07d570682d15e69"
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
    test_sql = <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL

    spawn bin/"rqlited", "-http-addr", "localhost:#{port}",
                         "-raft-addr", "localhost:#{free_port}",
                         testpath
    sleep 5
    assert_match "foo", pipe_output("#{bin}/rqlite -p #{port}", test_sql, 0)
    assert_match "Statements/sec", shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end