class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.5.tar.gz"
  sha256 "121e9e668477c3c19cd6cb1325838d4f5d2aa9c346fecc374d7c3c7f37d2aac6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbc904d4946c6f9a0257b24157e836bcb5a353093a3750fd4018e6e475b079cb"
    sha256 cellar: :any,                 arm64_sequoia: "3062ff432232d1bc4f9f8d3af67099af3706f7a475d17f1f1782100d82bba6be"
    sha256 cellar: :any,                 arm64_sonoma:  "346661974c6308679c182cf375f930027ace827a41d88f49e4f11a029bdc8ed5"
    sha256 cellar: :any,                 sonoma:        "64e52a5b60695b11512289e2ccd7bab652db720bdde155517597033ee32f367b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46c52db10c4d09604d12c68770873dc623f9a9eddd34fd18c8b91daf4b830913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aec8d0164b7d969cb2123bf2334ce6068a788b83c2baa84686f30b184a18903"
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