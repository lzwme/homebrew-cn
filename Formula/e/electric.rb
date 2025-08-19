class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.3.tar.gz"
  sha256 "e6ec40afde0607269b4e2af0982416594856d96d4ac82abf6186841893c0a730"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ceddac9de9d3503273d5c5a924238c386e684866c2c64d1f9070596f5b5440f"
    sha256 cellar: :any,                 arm64_sonoma:  "564b7376d638ac55be9be3be7de7be984b4c33207ad3d6ab161f6620044dbe98"
    sha256 cellar: :any,                 arm64_ventura: "d7893dc7c7301f52f06e97bc397d764fe9ea36fcbc23f683d4dce0df2dab643b"
    sha256 cellar: :any,                 sonoma:        "fdbce79110f70ca36433f3cb391774110799543a4b3837a75800cbd2602caf0e"
    sha256 cellar: :any,                 ventura:       "f4e84fe711a46f13d71bc54e362a79f3665cd68fcdf7f0842fd2796b2be3c6c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ff090986cd1386cf89e69580a64662c09dad28887b5551edad2eac0040b53e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5814bc3c08a136729d6f5af1b3b39493e28c1deb08d4c0698f9d1cb4a0de9dcc"
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