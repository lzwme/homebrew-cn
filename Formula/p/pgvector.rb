class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https:github.compgvectorpgvector"
  url "https:github.compgvectorpgvectorarchiverefstagsv0.5.1.tar.gz"
  sha256 "cc7a8e034a96e30a819911ac79d32f6bc47bdd1aa2de4d7d4904e26b83209dc8"
  license "PostgreSQL"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc40059d63530149d7950c2ebd9872558313b0dc230917f9a69ec6aa796b3da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99cd431973aefb5caa8c35db43f00c161a487211956637857155c2b425bca09f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829fa449e128958207ce3b53bb4c16e9fcb69af230c1f71a191baff974179814"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d17a5b3c627e21075141d1432daa9509a8bfc93255f7ac48e34eb3416602fa7"
    sha256 cellar: :any_skip_relocation, ventura:        "533703fea6d1a6b1fab8640e011e91938c71164a70f92b72a8c009edd6d58593"
    sha256 cellar: :any_skip_relocation, monterey:       "82256d1f4d9ff31e38f95bb31bdc8bfb3e183527e033b2e1af7cf751f69b1972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "649f86a00797d426f51ccafdb918c71a1a5cb0f0646c85b71cdabcdd36e95b99"
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