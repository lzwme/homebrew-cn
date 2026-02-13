class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.4.tar.gz"
  sha256 "f2fece99b6c422e425365aaf96e6d1a071d6ffdac2fb19622beedf5295f9193b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a0aa98394ab4494ca66d126003fbf10129af3d3195c557881408a096eb195c6"
    sha256 cellar: :any,                 arm64_sequoia: "219317abc432e959bdc1e60e4e6fb639135bf7bebb66de551e11b01de04c1081"
    sha256 cellar: :any,                 arm64_sonoma:  "2156046fc59400c597242cbdbc3bf901d9ddb6932a9b7e5dcd75717cbf9658b6"
    sha256 cellar: :any,                 sonoma:        "8a01d3c04343264505fcbeba7654fb7abec442984dd294e187cab324ccdd667b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189104c44f809e52e3c8c3ec9ac407cfe88b2102f67bf6f70c87095c5c134a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a902a0ef97d38af04090dae9820a07929d1ef45f854275f72d86781052c998"
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