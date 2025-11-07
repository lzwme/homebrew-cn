class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "8352fb6bb8aa8bdfdd94a8283f8430df19878ce9980a3c527b5eab530506c9cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba9ab1405556bf0b7e45d8ffa555931127dcbc0373f261f6ac2d4420f2fd439b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9ab1405556bf0b7e45d8ffa555931127dcbc0373f261f6ac2d4420f2fd439b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9ab1405556bf0b7e45d8ffa555931127dcbc0373f261f6ac2d4420f2fd439b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a556815d928f4a051efaca2114f8f41949627e7d6e5cda426ae1e195395f28c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33858361796ee7539899fa7578d8f9a59fb7d734dae3a6e45c84b8a470c340ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeab7e2640b91965caaa5c49535a88842cf89afa10a497e7838a92064a22fe97"
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