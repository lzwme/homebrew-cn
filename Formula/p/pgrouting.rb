class Pgrouting < Formula
  desc "Provides geospatial routing for PostGISPostgreSQL database"
  homepage "https:pgrouting.org"
  url "https:github.compgRoutingpgroutingreleasesdownloadv3.6.2pgrouting-3.6.2.tar.gz"
  sha256 "f4a1ed79d6f714e52548eca3bb8e5593c6745f1bde92eb5fb858efd8984dffa2"
  license "GPL-2.0-or-later"
  head "https:github.compgRoutingpgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cec7efd54e63fce3dce63590397653ee5bbf190964995eca46993fafa56ff9f7"
    sha256 cellar: :any,                 arm64_ventura:  "8a7253eb4ce95e34dab7a645ca7f45911e9b737726325a4111084b6a1e11f1c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9563bcbaf3a1f533d47b92e66e9f9e79b1aa670774f4d1b74e23e386c842d47"
    sha256 cellar: :any,                 sonoma:         "dde76b09dc23718b92955b7395e7dc9d8b8eb3e620db67547c191a243104d911"
    sha256 cellar: :any,                 ventura:        "a3ce7d7503fcbbdc62738db58500c6cdf7908a36324987cbff67f5b981277a92"
    sha256 cellar: :any_skip_relocation, monterey:       "0e19eab49d6a0301ec17e845cc49018e17bf30ef76834ec7fe2a5bea3f4fcc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6a24c91d35a547484d1dd1e5630960c665977f50404d5f17bfc5107811f998"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DPOSTGRESQL_PG_CONFIG=#{postgresql.opt_bin}pg_config", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}stage"
    end

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

      shared_preload_libraries = 'libpgrouting-#{version.major_minor}'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end