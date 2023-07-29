class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-3.3.4.tar.gz"
  sha256 "9d41eaef70e811a4fe2f4a431d144c0c57ce17c2c1a3c938ddaf4e5a3813b0d8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.osgeo.org/postgis/source/"
    regex(/href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "178b092fe1aea95fe8b34b5b34bfbb60568c22f521a08ac9b88af341987c3ac1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eef4f3a9b5671c8552584b860a5f5f8c8c011a74c2035e9b3a6bde5aa96f660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "986ce3816c69c74ac74f5385a45e130ca7241721ed03a5d143ef9a826086193a"
    sha256 cellar: :any_skip_relocation, ventura:        "facfefd974f4f6ad80850e77f9c996bf66d9dea982d2083436a8031bfcf0106e"
    sha256 cellar: :any_skip_relocation, monterey:       "2d844531ff7f4da2b6c7dc9fd4951c8f4f5586fcb8b1ac0521e8876185b0cce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1bfc405183f59411120c5d87b5a0291125c81d743f3522883ee990ea27286ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2209aff6e86e65e0b387d6c6c1dd40fe3e6570dfeb9d8783b06c14503f681854"
  end

  head do
    url "https://git.osgeo.org/gitea/postgis/postgis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gpp" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal" # for GeoJSON and raster handling
  depends_on "geos"
  depends_on "icu4c"
  depends_on "json-c" # for GeoJSON and raster handling
  depends_on "pcre2"
  depends_on "postgresql@14"
  depends_on "proj"
  depends_on "protobuf-c" # for MVT (map vector tiles) support
  depends_on "sfcgal" # for advanced 2D/3D functions

  fails_with gcc: "5" # C++17

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV.deparallelize

    # C++17 is required.
    ENV.append "CXXFLAGS", "-std=c++17"

    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    args = [
      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      "--with-pgconfig=#{postgresql.opt_bin}/pg_config",
      "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls",
    ]

    system "./autogen.sh" if build.head?
    # Fixes config/install-sh: No such file or directory
    # This is caused by a misalignment between ./configure in postgres@14 and postgis
    mv "build-aux", "config"
    inreplace %w[configure utils/Makefile.in] do |s|
      s.gsub! "build-aux", "config"
    end
    system "./configure", *args
    system "make"

    # Install to a staging directory to circumvent the hardcoded install paths
    # set by the PGXS makefiles.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    # Some files are stored in the stage directory with the cellar prefix of
    # the version of postgresql used to build postgis.  Since we copy these
    # files into the postgis keg and symlink them to HOMEBREW_PREFIX, postgis
    # only needs to be rebuilt when there is a new major version of postgresql.
    postgresql_prefix = postgresql.prefix.realpath
    postgresql_stage_path = File.join("stage", postgresql_prefix)
    bin.install (buildpath/postgresql_stage_path/"bin").children
    doc.install (buildpath/postgresql_stage_path/"share/doc").children

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children

    # Extension scripts
    bin.install %w[
      utils/create_undef.pl
      utils/create_upgrade.pl
      utils/postgis_restore.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]
  end

  test do
    pg_version = postgresql.version.major
    expected = /'PostGIS built for PostgreSQL % cannot be loaded in PostgreSQL %',\s+#{pg_version}\.\d,/
    postgis_version = Formula["postgis"].version.major_minor
    assert_match expected, (share/postgresql.name/"contrib/postgis-#{postgis_version}/postgis.sql").read

    require "base64"
    (testpath/"brew.shp").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoOgDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAEAAAASCwAAAAAAAAAAAPA/AAAAAAAA8D8AAAAAAAAA
      AAAAAAAAAAAAAAAAAgAAABILAAAAAAAAAAAACEAAAAAAAADwPwAAAAAAAAAA
      AAAAAAAAAAAAAAADAAAAEgsAAAAAAAAAAAAQQAAAAAAAAAhAAAAAAAAAAAAA
      AAAAAAAAAAAAAAQAAAASCwAAAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAAAAA
      AAAAAAAAAAAABQAAABILAAAAAAAAAAAAAAAAAAAAAAAUQAAAAAAAACJAAAAA
      AAAAAEA=
    EOS
    (testpath/"brew.dbf").write ::Base64.decode64 <<~EOS
      A3IJGgUAAABhAFsAAAAAAAAAAAAAAAAAAAAAAAAAAABGSVJTVF9GTEQAAEMA
      AAAAMgAAAAAAAAAAAAAAAAAAAFNFQ09ORF9GTEQAQwAAAAAoAAAAAAAAAAAA
      AAAAAAAADSBGaXJzdCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgU2Vjb25kICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgIFRoaXJkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgUG9pbnQgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICBGb3VydGggICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgQXBwZW5kZWQgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAg
    EOS
    (testpath/"brew.shx").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARugDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAADIAAAASAAAASAAAABIAAABeAAAAEgAAAHQAAAASAAAA
      igAAABI=
    EOS
    result = shell_output("#{bin}/shp2pgsql #{testpath}/brew.shp")
    assert_match "Point", result
    assert_match "AddGeometryColumn", result

    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'postgis-3'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"postgis\";", "postgres"
    system pg_ctl, "stop", "-D", testpath/"test"
  end
end