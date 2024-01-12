class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https:github.comcitusdatapg_cron"
  url "https:github.comcitusdatapg_cronarchiverefstagsv1.6.2.tar.gz"
  sha256 "9f4eb3193733c6fa93a6591406659aac54b82c24a5d91ffaf4ec243f717d94a0"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "46319669501a68f85486f03718757c445232a2cda06fe4052c72f06305952a93"
    sha256 cellar: :any,                 arm64_ventura:  "a4b25202758f71ad9ccb2b79959cc9b7c360c8a397063c823b76b65214a22387"
    sha256 cellar: :any,                 arm64_monterey: "24ccd07d3b6fa08211e39698f2cc8e964fd8b3785df6ff8eb491947055d40d78"
    sha256 cellar: :any,                 sonoma:         "a0bc2b517f51094f790ae767c91aa673f54d9a47637ae52c845a1783a695b4fc"
    sha256 cellar: :any,                 ventura:        "08d8db4d45809be10db49e8cddfec6ed2d09b3a3f0158f86f4c02f3df070210e"
    sha256 cellar: :any,                 monterey:       "517cbf786d644a14d59dbc8ea8db6021a442ae2d3735592c3cb3a9ef28a899c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8abe1eb67c86d1380d0c44dd7ff20c4498226ef6e43ab95d4b15ab06a5309f"
  end

  depends_on "postgresql@16"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https:github.comcitusdatapg_cronissues269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    system "make", "install", "PG_CONFIG=#{postgresql.opt_libexec}binpg_config",
                              "pkglibdir=#{libpostgresql.name}",
                              "datadir=#{sharepostgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec"binpg_ctl"
    psql = postgresql.opt_libexec"binpsql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_cron'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end