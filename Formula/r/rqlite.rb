class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "d025a4ce5947c4e926f63a540ff243eedeee9e0964f4d5faca6fe178e400d10c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24860c9be24ccb83972c477710f885f0c634602b79c8df813aba2851ff990f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5284751d0c641a92720d245bd1ae5eb5d535ee197e091764c170a73d2d3431f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5288d98eab2471b8b39f2bc29092fbc1bc9d9e67e771e5a350ef3c1cf01279"
    sha256 cellar: :any_skip_relocation, sonoma:        "5acfed6b4910f51b453a004eb986932f7bfaad182ddb511f64c48b97f22856de"
    sha256 cellar: :any,                 arm64_linux:   "9d9b5f09b5ccf4d5191b95ca4a39a8a2ba19b4ad7987ed4689bab5cb4d102719"
    sha256 cellar: :any,                 x86_64_linux:  "9234224a5c7b67f4e26c83240fad5a2a2c800ba6c48e971e21e91c8c4649c2bd"
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