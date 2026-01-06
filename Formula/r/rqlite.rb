class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.10.tar.gz"
  sha256 "92b25b2a0628eb05a2dab97cbd189039a1a57ff8adbb1f5817959909b2d530e8"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b18630c81371894d2bdc379c8a273c5e8868f4f2fae1361641754c275dca8d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ed481da4a634a535ae6af1c3bae538174e939a0350388c5c07461663ae452c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900c018ae8480e3a55fae13ab960c9736eb7286c729a1418016143d017f7d372"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe5649e76fb1dabd628166bd9f2bc74e2636d985fbddb56a44b636ffbeb71a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "073c39c93b87914a370cadd31242d2a890287d1e04fb40a83c8c75350ad86c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d7e6cb8a42be136f85dcbca42dec1a4e380fa99a60ec281df9ed0f84f4ba406"
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