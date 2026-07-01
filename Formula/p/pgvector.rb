class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://ghfast.top/https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "08575cd4a9d612d36dca821aa53e82c014aba8ef34c4c12d6ef6bff9f1093ef2"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32e95937e1054bcf6e15107319ec1f1218287167b25ef3c8c3c09b73193cb70e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02ff402c0785d4be55aa4d3c210fc304d37c9579afe14899c60abb50ca6bf59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5426b36cd37f4993c58447e5a142e777adc7be2a054fb6b5b5822c00bd86f7c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c906c6bbbee3f07f41509cb97770638a1bc8073c83fdf067c2dbc1dc595f688"
    sha256 cellar: :any,                 arm64_linux:   "512f73941d911088f36697e2804dd8f92b43ae37bb39fbd1c5aae55293d0f3e8"
    sha256 cellar: :any,                 x86_64_linux:  "13b9e197f467bb816b5d65121404b0f9cb209c70b46064b665f270114434095f"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      system "make"
      system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}",
                                "pkgincludedir=#{include/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end