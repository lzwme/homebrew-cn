class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https:github.compgvectorpgvector"
  url "https:github.compgvectorpgvectorarchiverefstagsv0.7.3.tar.gz"
  sha256 "48d8faa326188bb59e9054f5f77a2a40937e26b8f9a20da4bee54a12bff1e72e"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43a4942f3705f17a57b6c847414a8c4dcf8655e0ec28299b04bdd4865930247d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9ac4a288fb752deee5af1482c0a7d161bd08d00d32a7af3b38ba036427045a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067f453d9b1f5abcc8cd2aa8cc9618ad2a10196986a98c6f60596c4b5bab6dd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "25bfe9d70c73fe44618d0992c68e3a610d46ba07022caf1f389b7f50e7a3cbc0"
    sha256 cellar: :any_skip_relocation, ventura:        "b1cdb34afd1dcda7f1b794df240ccfc0eb848ec6e8614832f31f0c4f7148dee1"
    sha256 cellar: :any_skip_relocation, monterey:       "598266c2940c71a70f3c96dbd512063f6729de7b4ebe5ebda54e68bf37b424e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9328c69cb643b4385f3fc625fdc8d2928c1c222fca16f58c60683929c15fe3f7"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin"pg_config"
    system "make"
    system "make", "install", "pkglibdir=#{libpostgresql.name}",
                              "datadir=#{sharepostgresql.name}",
                              "pkgincludedir=#{includepostgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin"pg_ctl"
    psql = postgresql.opt_bin"psql"
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