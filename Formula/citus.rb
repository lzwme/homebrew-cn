class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://ghproxy.com/https://github.com/citusdata/citus/archive/v11.2.1.tar.gz"
  sha256 "d500f216f233068f9643136759c0b029a0c940734a07fc309aad49a213f5169b"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "194b6af5918739a71283cd3c8820d930bdd04cfe6d110c9809a1ac5e62083f47"
    sha256 cellar: :any,                 arm64_monterey: "902e3c22ce9c3ec7642fe0b7ac05561845cb5732f0f9dc69609a4b0c05007004"
    sha256 cellar: :any,                 arm64_big_sur:  "78bdee49f4610870f40c13ccf26766550ce60779cd2938f18cec697564712c44"
    sha256 cellar: :any,                 ventura:        "00ba50df6d61665b0af89e770d87771221c7407cb076dfbea40e370d3e5c33e7"
    sha256 cellar: :any,                 monterey:       "783d1712bc9d836d3a30ef4ca482d67b9786f2b491a13fe441c85682b84b3fe5"
    sha256 cellar: :any,                 big_sur:        "c741e0f6e55040a884b658dd9967bf40dc1593661cfb1ad6b5b8fed561abdd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780a26509b75a41e2aa04a7b003ecf86a55e2513a44f7d7b7b3f78de1868e719"
  end

  depends_on "lz4"
  depends_on "postgresql@14"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "./configure"
    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{postgresql.opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    include.install (buildpath/stage_path/"include").children
    share.install (buildpath/stage_path/"share").children

    bin.install (buildpath/File.join("stage", postgresql.bin.realpath)).children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end