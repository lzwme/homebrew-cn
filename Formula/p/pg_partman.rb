class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https:github.compgpartmanpg_partman"
  url "https:github.compgpartmanpg_partmanarchiverefstagsv5.2.1.tar.gz"
  sha256 "0c4e047b2298a527fe023a6aa8f82c5c9d3d5f964363a339438ca6a5ce50835f"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc9f1a06b01f41fb014251b322aab99db4c59ff655d1d31ff8fc7fe89f383f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b18c604d10bceeaa3ffdc58afb21cb24d5c897ce8ddb44775e8591d8af00c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c0e6e25c14a5260fd640456f5159393818b077452b0dfc341f2a894fd60639"
    sha256 cellar: :any_skip_relocation, sonoma:        "e08aab4f0fe6fa95462ddd79c5f376e31f227b11e73db9edf4661b746dcffc93"
    sha256 cellar: :any_skip_relocation, ventura:       "7ee5e4dbd75f2aeeacc84f9abf8273ec28f58f295929e867aead8b5e435ddb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86139d19fae4463e8a91d437f57efd98566a6b1ab48056fd0eff141a3540230b"
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