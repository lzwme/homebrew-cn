class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.11.tar.gz"
  sha256 "363d420cac2e80e025be0d7b66ad689dc4ea816c3be930db5181868f3fd2943b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b053c3f2ca408e0af9da86481305fba5562562cb4384f4460afccf3e78d2ff1"
    sha256 cellar: :any,                 arm64_sequoia: "a6f82cb3f6b9efdce5541cb18aa3438825bc85141fd3fad0f11872f16b6b527e"
    sha256 cellar: :any,                 arm64_sonoma:  "49bd1ab87be90e3125bd05513dabe733bb5b6f096f6ccd11561ade7175e29d16"
    sha256 cellar: :any,                 sonoma:        "ca582bb26edb0afe328a60cbf45ab2d1e10a8ddaa8e89b8d77a6c9316062af56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e89bd1085057474dcf52588bebc47d09897fb8120b63148423ecb44b3c5268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90494f206d7c9336cfd3be7a864a39b389da02f5762604b9887bdfc04a75709d"
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

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end