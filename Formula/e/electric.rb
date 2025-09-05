class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.9.tar.gz"
  sha256 "5de384e5857735f659317edaed328f63ea7ca4d04b74fd3fcba88deee8246618"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74fdebf3eddcc54d7aec7721146aa1dccf3a0c663bf2e07377cae41f973ec7a9"
    sha256 cellar: :any,                 arm64_sonoma:  "83c3c7dfa31a5e8526fa9cfe390d1d88e1b5cc82f7308f739b69a8f1bbf00570"
    sha256 cellar: :any,                 arm64_ventura: "6b7fedf89bebdfa51bc20e88b58fee58b5ce6af0aca94eb2b300e88f55ae282f"
    sha256 cellar: :any,                 sonoma:        "a1f7fdead1e5537cc5e758207b4a95da6c971e85f256906ddfef4f95526cdeff"
    sha256 cellar: :any,                 ventura:       "2e85d5772007acfa60973cf2c4ee2bb7d7e6ff9f6b817836fed5cd694490e55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e88ebee3bb694a9016c38196a6bd3a4729829b9da37166f4a8a43fe5c763de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7dd10793c1b4c176b2df9585805eefa3368a6760622a3f0b655471aeb159edd"
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