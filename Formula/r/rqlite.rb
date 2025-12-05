class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.4.tar.gz"
  sha256 "24bbb51923786f840872bf39644ee7954f5993dfba2779c8ca6f530ed785f84d"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0f1fda8bdc6d86f3aed5e83d7406f52b4c335c3718d402e46e8010d6041731a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ee5daa3d24e94af846ba7bffb31d5616d3510411088e950367931174a816072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d769beac2ea0708f717fedef7683c99f70c491d18829498706d3e3044c6da88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "20392309e902601ec70c1a6fde6855e03e938d0f6b385cb0a43a4796e080ebff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0e310015cc2f3d0e02bd30729a20325853d8312d78f92d62ab1999126aa0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb66b25abb8bdea22503dc1da5aad4d0ada0198ccffdccb925c8a8423e7267b"
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