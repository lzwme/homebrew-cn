class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.8.tar.gz"
  sha256 "ed4afd9b403c393ecad21cd93761dc0751a0abae6ec03d38ae9d0da1016bccbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec67c0539b1bb284ca387b1f88f9ba98dcec569520bbc46955398c495a4961df"
    sha256 cellar: :any,                 arm64_sonoma:  "e7e2c01752fa5e009b9d1fb99dbbae02305a033bda73105e71cd670d9628654f"
    sha256 cellar: :any,                 arm64_ventura: "3d45cd1c9d1eba9682b57dd82563561af3d66784228e4982ac0cd6fba884f61b"
    sha256 cellar: :any,                 sonoma:        "264d75927e4b8deda0812268a2146b37be6d2f3d54e319b805ab3d5111f699ed"
    sha256 cellar: :any,                 ventura:       "4e0bfa216c8352c55f0eca04ef4b75649c20d75a890efddb167d56146f9e97a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f32dd12aeaa904b1840c1e0c4e7b4ed761b1c4aaad626387f65c44433cf2536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56f2dff2c30610c2801c86cd8b28467b87b0e123670acd2d88b31b022c9114c0"
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