class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https:github.compgpartmanpg_partman"
  url "https:github.compgpartmanpg_partmanarchiverefstagsv5.2.2.tar.gz"
  sha256 "c67898c7b131d66b835b44d92013e9e07f0834b253505ef2808de6826e3e558d"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8a2d74617d5cd8a5ad3551405e33804c14c1e568e2a32a9681be48c4350683f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01b6b2b975c1a385bfb04bb939184c836d66ae5af851d0d63dccd42184de552"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81653ea3a8982418dc0c52d9d5c90d221b99a36ee32de40786e2f9314d84dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6996a3477d03ee5a6d907789d4a75a9da60d4eaf9717e8f98d2054208f354aab"
    sha256 cellar: :any_skip_relocation, ventura:       "c6759ee065d0d726f1d9b001ffb8a532c2063b190a811916c82e1c14ca5637fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1eeb5c7b4e011002c6d7cee8b607665525d2eb7252581a014a39c8bce4bd747"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin"pg_config"

      system "make"
      system "make", "install", "bindir=#{bin}",
                                "docdir=#{doc}",
                                "datadir=#{sharepostgresql.name}",
                                "pkglibdir=#{libpostgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin"pg_ctl"
      psql = postgresql.opt_bin"psql"
      port = free_port

      datadir = testpathpostgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'pg_partman_bgw'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end