class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "ccbb86b27f6d4edf3488ea671f846876fddc0808baefffa7f9c45e4e501045a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "946623a2fd006f830d6d019c6755c9ddf1bec92ffda77f28716711005cc9ae18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946623a2fd006f830d6d019c6755c9ddf1bec92ffda77f28716711005cc9ae18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946623a2fd006f830d6d019c6755c9ddf1bec92ffda77f28716711005cc9ae18"
    sha256 cellar: :any_skip_relocation, sonoma:        "697038513a5aa00aa051ea1a38ce03933e58a9a15eca05373473c23ff009d027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e523f6c726565ff33e2a3b49beffc0838c4a29e12cd07831d53efc2a9da21425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd406d713f4d9d0ed9adb069c918801252fb9bb3d24b28573bbd8dc408757ea"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end