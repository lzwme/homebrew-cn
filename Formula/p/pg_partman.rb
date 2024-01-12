class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https:github.compgpartmanpg_partman"
  url "https:github.compgpartmanpg_partmanarchiverefstagsv5.0.1.tar.gz"
  sha256 "75b541733a9659a6c90dbd40fccb904a630a32880a6e3044d0c4c5f4c8a65525"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2d729a6cf7ad10cf391030757a9a0dd05347792830826319d51b680bf94a3b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcbf1e27f798752c6e5955d1e822341e1c9593e7fce2e97ca2e84e8b13b320b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6896bc779c8a394aeaa9157db815288627d651c71c1712aca78859013e774461"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb09ddcf56bc40a73ba71065a836a7b851bb2b1c7d9d809ca1ae98f5f429a057"
    sha256 cellar: :any_skip_relocation, ventura:        "f7f03498b38c41f540028a9cb703a7eb8eadc31a50e32e6594a0bc313eb379cc"
    sha256 cellar: :any_skip_relocation, monterey:       "ed17fb0c97c4a1bf3ed43298f1aaf2df779dc020a26066f8d42682170840cca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f22aa2166c3662412f4e04b41abe48f3d6a9272c786e689493989676cc9a4a"
  end

  depends_on "postgresql@16"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_libexec"binpg_config"

    system "make"
    system "make", "install", "bindir=#{bin}",
                              "docdir=#{doc}",
                              "datadir=#{sharepostgresql.name}",
                              "pkglibdir=#{libpostgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec"binpg_ctl"
    psql = postgresql.opt_libexec"binpsql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_partman_bgw'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end