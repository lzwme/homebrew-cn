class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https:github.compgvectorpgvector"
  url "https:github.compgvectorpgvectorarchiverefstagsv0.5.1.tar.gz"
  sha256 "cc7a8e034a96e30a819911ac79d32f6bc47bdd1aa2de4d7d4904e26b83209dc8"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "314a8501335fa515421bca8d5a9b1613a7450a64823e7bb472059e023456ca42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ba5f02c51017a7c6caccf80d2e45d8589dbe95f27cae25bd0667c40d48ca6c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b42114e8f1570a2c0d8b17867b2ae946564f82a7657b8324d00b7dd9e500d124"
    sha256 cellar: :any_skip_relocation, sonoma:         "315c0b2e3e45ce311aa101357a06c4c98b3dcf2971c172dbfb00980756792752"
    sha256 cellar: :any_skip_relocation, ventura:        "d7b6f0de11920424a6fa5705a166ae40b01abbbf4c54176e9ec5603bbeaabb6e"
    sha256 cellar: :any_skip_relocation, monterey:       "4e19680f3fc909f4fbcc6a76be8d7c2c2984d5194887ca1a36adce5cca046ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195acce97a366c3ae066ea91e146dfe87d8e073c6e6edb0d97a8a10f9d6dcfdc"
  end

  depends_on "postgresql@15" => [:build, :test]
  depends_on "postgresql@16" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_libexec"binpg_config"
      system "make", "clean"
      system "make"
      system "make", "install", "pkglibdir=#{libpostgresql.name}",
                                "datadir=#{sharepostgresql.name}",
                                "pkgincludedir=#{includepostgresql.name}"
    end
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_libexec"binpg_ctl"
      psql = postgresql.opt_libexec"binpsql"
      datadir = testpathpostgresql.name
      port = free_port

      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end