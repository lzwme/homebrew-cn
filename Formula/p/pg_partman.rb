class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https:github.compgpartmanpg_partman"
  url "https:github.compgpartmanpg_partmanarchiverefstagsv5.2.0.tar.gz"
  sha256 "4c70be7517200f0c1c24529f575c34580e0c7b18ea15ccd977fd3dfff416d627"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5790dbb821d350ef8b585d625ff3318e49c43c96078715f10cffd287cbc738e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede6ee75199f588054f8a9c994a07e802680465099023b8a1f3fa95c49870edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b955b7644cff19bbe80387bea4218aa0bc73a386d8244b3957aeefa27d93519"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c6f640431fb03017297e4dc09557f44c66f1b417ebd27d16b19cd6bb419c748"
    sha256 cellar: :any_skip_relocation, ventura:       "db06994df37c28e3bf48c8754d8d3c69440084a59dd9c68819861d2c5914c14e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b317aba71f4112cee9b5a0464e5692e81511917d750e115629e695bf3559a35b"
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