class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.8.0.tar.gz"
  sha256 "1e2a0e5faf1900aa2458e624f3e98c5d5686d86dc1c7d2d3e46de32322ce07de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aa55d2656c5cb92fa1e5c3d24b41c5062f1884a749aa63e31fde2cd52ada3f1b"
    sha256 cellar: :any, arm64_sequoia: "ae0d9cd21f28e86ab17eba89b9423a3365604cf098166966a53b622ace562ecf"
    sha256 cellar: :any, arm64_sonoma:  "b57e5cd9f9aa231e393f216da9d420460d34525ccf40498ace4f895cd81b8cac"
    sha256 cellar: :any, arm64_linux:   "aa06147e07aeb64ae1ff4e62156a30c4f20c9408b43f2f092f78611c09a15252"
    sha256 cellar: :any, x86_64_linux:  "6fca1979bb6cafe48342631bc226988de65d6a32dc7c3d26a3a31770fc0e56a5"
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