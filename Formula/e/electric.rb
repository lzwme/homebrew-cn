class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.4.tar.gz"
  sha256 "ebd81d1b6d4413da53fcce9028aba0702d5dfbe982cb2321e1374d201fcd5d12"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4d2a5a96f1721a88faae3ee7f32fedb07f24833a080d8545ee9b369ea52c3f1"
    sha256 cellar: :any,                 arm64_sequoia: "61ec7950b0ba55577bdc8671c31a2465b11b7171ebff7ed8148ad24fa65695a2"
    sha256 cellar: :any,                 arm64_sonoma:  "497cc7d0331fe9b1eba90893b0b5f10c33497324d56df143e6735e442d830ebb"
    sha256 cellar: :any,                 sonoma:        "afb374127208d165fb300218672a7d8a4b59e4c6502bece8085fefa14284e1b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "319e47e18c3bf4bd27617bd9595c19e4009a4f6577845f5635b3ff25349418e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13f30aa96dc8c231f2f475dc58f1e6e90d28ee18a80ec0117d20bf4fb97c3e2b"
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