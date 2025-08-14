class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.1.tar.gz"
  sha256 "43d0a02742bf5642d6963992c67da6fefa86ab972d8fa9ae37ca2c2f1bce08ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "daff2b64b944902127fc019075dc1ed1de883730464bf70e325c81298c2aff98"
    sha256 cellar: :any,                 arm64_sonoma:  "09b942fcbf106e55a613256d1cb9fead230d746649c0f6e912ef393f095ae962"
    sha256 cellar: :any,                 arm64_ventura: "ea3dc0fdf71ba9ed9e165c4eef2b20dfcba7098a699c858c997e4f3ac6c3ff3d"
    sha256 cellar: :any,                 sonoma:        "d770dbcad4f6c240dabc61ae113ea1f6e5a21f7182d322bf46ca38f06b7dfb0e"
    sha256 cellar: :any,                 ventura:       "dad600c6356d6c5ec6671b3f3529ba5ab95ee25afe22073c7f288417b70467ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89943c061cb5e5a4be9cee4d7ee18aab31f2472dc5510f28dc09bcac38d2d219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6289c644eb56cd7cadc868481e1a314c3a48b41501ea92fe9c013cc748604a74"
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