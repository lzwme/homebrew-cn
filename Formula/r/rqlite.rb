class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.4.tar.gz"
  sha256 "6149795f04f0c0d058ae1593e25d9e57bf76f2fb611532096d2c5ff061dc0e28"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78530617a26404abdc37c1d2d989da2e2fedea58eeb7878000840221db1f86d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d06ce405461fb8dccd6a7e1221c5bc460948f2ea886fd5e85a4225966d9c7ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb9b4514a4300a200359dde8178c8829ac495bf13fe362d71ca287c4281d9b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a785530aa8354acc7e5b0c3d627a7a291a58f34846684e960eed3b37a1add8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a6dbbd57dfd781ced5c7672840d7abb2beef17f216197f81606f448cf787ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb4f892d3d68b516555adf7afe00d30cc4de5d49c0b10ab007224087f69f5f1"
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