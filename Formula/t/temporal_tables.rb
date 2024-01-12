class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https:pgxn.orgdisttemporal_tables"
  url "https:github.comarkhipovtemporal_tablesarchiverefstagsv1.2.2.tar.gz"
  sha256 "85517266748a438ab140147cb70d238ca19ad14c5d7acd6007c520d378db662e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32ee060448c99dfcde71fa12cf00e928327eb870da4fb89ee5da2e9620c25c64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e419e0e1a6ea32600dd16f797c4b4cddae8c378ae275ae0d426cb74515d4150d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9c7cb115fdea71ca9a7707c533a6389b01b3d0873af7abaf4c98d3cfb093cb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5cd432d47f0b3235c1d3140bf0603eb36e09d3ec4a9470087579f4d13fae760"
    sha256 cellar: :any_skip_relocation, ventura:        "83c9f4b1cf56d8aa988bc74fe6ee8134e78a3523e12275ddacde691928995f90"
    sha256 cellar: :any_skip_relocation, monterey:       "305e2c5302756ded35110287b104e635c4a8930897a9b696006987bd2ba9342f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fbf23af17784bccfed9a768e3e09625b47723ff7ae38d076dc99867ec881ea5"
  end

  depends_on "postgresql@16"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    system "make", "install", "PG_CONFIG=#{postgresql.opt_libexec}binpg_config",
                              "pkglibdir=#{libpostgresql.name}",
                              "datadir=#{sharepostgresql.name}",
                              "docdir=#{doc}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec"binpg_ctl"
    psql = postgresql.opt_libexec"binpsql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'temporal_tables'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"temporal_tables\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end