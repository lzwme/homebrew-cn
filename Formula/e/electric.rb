class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.7.tar.gz"
  sha256 "10898eab1ba7acef571aab92ce99cbced6aadf834e7ced178f424f64f36230f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "732aa9d69ac9518a4900b83ff6021414c3403bdd0f58c4f37609d4a8fb847c65"
    sha256 cellar: :any,                 arm64_sonoma:  "28ef284461e8cdfbd89990e0f019c55c76f5b2390fce184ee323f4161df937e2"
    sha256 cellar: :any,                 arm64_ventura: "320fd91bc56a05f6cb292ee2f0f414006ee63e2caa22e80fa2578ee0732324b8"
    sha256 cellar: :any,                 sonoma:        "de7917c5fdca1683a2a5fc157270f689d0651074e4dd0d0595a5d39e6ad6dd62"
    sha256 cellar: :any,                 ventura:       "db790f3e4e1df6827827af5e3920275008c3dd2a68ea9b9f5072481f8fbaf992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "918a604907384c1d3525c2267914773d783e45d84f005416021833fbe8f9c62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d42537a5b87c82cf249fc9772134a8e55cdbfc16d291911dfc4314e2c4734c"
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