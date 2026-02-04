class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "118fb17bff99a770883b9387f36cde612ce1d53bfc92c31fd198fe6093a41d3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d892e811ac7b8444ffa93397dc93e2d47ee58fc9ed7db016f293341cc4d8c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d892e811ac7b8444ffa93397dc93e2d47ee58fc9ed7db016f293341cc4d8c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d892e811ac7b8444ffa93397dc93e2d47ee58fc9ed7db016f293341cc4d8c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f1ea5c35be9d82a5e739926a1648c9604133d3f936b29e49d901f95e000c692"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bca5b2e36ad3da373110e67141417ee0a2439048a8c67bf0d4bca11ed1860665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d71cb75251b6601102050d2ed6b6002b5d99504a70d7ab3127c81e28ea660c"
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