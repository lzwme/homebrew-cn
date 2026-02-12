class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.3.tar.gz"
  sha256 "322dd2e71838cdaec22264aab886082a168c1ecde487294e68c9f1af6cea81b9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccd32adaeea5aeb58380d4bb83d8d77f0d929ca58f884ed960e7759da8583553"
    sha256 cellar: :any,                 arm64_sequoia: "b0d2341f2d72f32244462a251a1e03998b7d741fd1d070b5659a957a938f38aa"
    sha256 cellar: :any,                 arm64_sonoma:  "795a7a93fec01c14a23fbb762d9e8cd48120fda6d14323154cc190cf47676a77"
    sha256 cellar: :any,                 sonoma:        "33c08533de0665c1d8ccdcf5cddc991e7568ad913b9b32feddcbe742d38b131f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13c946219893867adbcb472f3864bc33085c4b7e8fce26c41ea28650e32b1043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4f22647344c427c12f3de42e71d272a913ebc6ded0cbb9d86e9a62ffaada3e"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
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
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
      ENV["ELECTRIC_INSECURE"] = "true"
      ENV["ELECTRIC_PORT"] = free_port.to_s

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end