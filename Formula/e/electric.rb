class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.6.tar.gz"
  sha256 "6c6dd55e9e72db296617ca4e4186c96e6fb5311f793e5aad70494e5fd5fb0f11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2da2a25edbf1065b64dec6240fdc83d31d5347feb827f60736e8b0ead43b8a87"
    sha256 cellar: :any,                 arm64_sonoma:  "ff6cab9926067f7e2541b86be3363742932b1394268bda9920cbb3760b287baa"
    sha256 cellar: :any,                 arm64_ventura: "2bc64e45182ceaa83607ff190fe1f1c5cd049a7c7874dd4a14b5e2061f9ab677"
    sha256 cellar: :any,                 sonoma:        "53a924d4d1567f102030db1e98ce7cd64a4b44798347b8874d70b2c5f65924bd"
    sha256 cellar: :any,                 ventura:       "93726556c118e5e0ea3c95268d90516b69ad690de601e4922d8b2ee84699228e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd407a409b4556034c7ede36a04c05892bdc456088633d79923500a866ebaf7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048a885e56f8fe5703869da39e178695a69142b63320d20b261d5b61ebb488ae"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end