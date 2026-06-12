class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.7.0.tar.gz"
  sha256 "0c56bf3f77feb9bc2152c476e30f8ecb647833049b8bd61e6d8aa0ad4c1d4c4f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c42126aa7d89c595565d8739dbc05dc1a9d5a3b9d0a00c3eb0970d2d24a21bc"
    sha256 cellar: :any, arm64_sequoia: "972704afc22acb0fa95922a2ce11614c1fb0bc689ddd4591a941455329dac35d"
    sha256 cellar: :any, arm64_sonoma:  "eff08083b9dcf8ea5e080040668e9097722e9dff6aa4702ab3b94c14f788367a"
    sha256 cellar: :any, sonoma:        "bbcc33e9dd18dac5d2007e687a5794bf7c45cd035547de1ea86b062bcb91bcd7"
    sha256 cellar: :any, arm64_linux:   "c4a27e5781a1310b67d31d0fe6ef15e2e576c81da20c2af176cb959bb3c84641"
    sha256 cellar: :any, x86_64_linux:  "8147c7a97bf6db0aba1c84b1284cb12f4955db94d9348d56ed93f8336b96223d"
  end

  depends_on "elixir" => :build
  depends_on "erlang@28" => :build # https://github.com/electric-sql/electric/pull/3992
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release", "--path", libexec
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
    ENV["ELECTRIC_INSECURE"] = "true"
    ENV["ELECTRIC_PORT"] = free_port.to_s
    ENV["LC_ALL"] = "C"
    ENV["PGDATA"] = testpath/"test"

    system pg_ctl, "initdb", "--options=-c port=#{port} -c wal_level=logical"
    system pg_ctl, "start", "-l", testpath/"log"

    begin
      (testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups").mkpath

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      tries = 0
      begin
        output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
        assert_match "active", output
      rescue Minitest::Assertion
        # https://github.com/electric-sql/electric/blob/main/website/docs/guides/deployment.md#health-checks
        raise if !output&.match?(/starting|waiting/) || (tries += 1) >= 3

        sleep 10
        retry
      end
    ensure
      system pg_ctl, "stop"
    end
  end
end