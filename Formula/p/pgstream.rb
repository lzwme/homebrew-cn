class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "5caf9da0e3fbfddc1b84bd6fd5e822ed97b22b0de34a4a6d6fc92a083f23f461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3723e55bd6072d2eba6c887c31504989dcdcf81e9ec23848bfb306f3b1ade019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3723e55bd6072d2eba6c887c31504989dcdcf81e9ec23848bfb306f3b1ade019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3723e55bd6072d2eba6c887c31504989dcdcf81e9ec23848bfb306f3b1ade019"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8dc58fdb9e15bc2a7f86b8c01778bdd3effd8a3048c82712f49444e506bdaaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "960b1abce2bbc727e5563519f1b4245cff223ac985aecd5315801a8874d2aa39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "458cdab5fb13b830a1116e3b48d6714804d54cbfe632dc304cc57806cabd0ce7"
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