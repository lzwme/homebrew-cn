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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3439256a09f6b5ba2cdb9e7db565caf62c26bd6c6d3ec3d8848b50ac4363fd84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "188021cc902cebe9286202a66a1cbb3251c028733df5e81cdf9c16d40bb46b0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c77e85f0a99540b6f4ff3c22dc09f0682b7ade9cffeff1c2ec35017e2d0ee14c"
    sha256 cellar: :any_skip_relocation, sonoma:         "10f35710e7934b43481a4f551a422b6fe6539bbc1ffeb7d99289ff7fe89f1f83"
    sha256 cellar: :any_skip_relocation, ventura:        "1a1ef5ff8e73b0df8df1134e841b68be2a58575cbe8f688cac2d66ef173d6ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4a1fd509081672f14781805cd570d712954c73e5a4f3a434ca3198a5e59e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35187d653f58864f5bc79d688246fb84e6daa88f33fd6a2fe5e4804aee449583"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin"pg_config"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpathstage_path"lib").children
    share.install (buildpathstage_path"share").children
  end

  test do
    pg_ctl = postgresql.opt_bin"pg_ctl"
    psql = postgresql.opt_bin"psql"
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