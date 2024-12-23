class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https:postgis.net"
  url "https:download.osgeo.orgpostgissourcepostgis-3.5.1.tar.gz"
  sha256 "23706abc117fb1bab45a27a263b589f52fc08ebaff318c0bc0bdc940905306b5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:download.osgeo.orgpostgissource"
    regex(href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d00d54c4f7f9d6138577e4870af238c0d81ed6df017281b5c6cb7f42a34ea5f1"
    sha256 cellar: :any,                 arm64_sonoma:  "c2e11423d9c809c7acf8d6d5f47f6faa524ddfc4793fdbdf479636415c53c0b2"
    sha256 cellar: :any,                 arm64_ventura: "73650c06659fe45546754927ee14d4540bdabdb7d97e477d1355f65e481c0901"
    sha256 cellar: :any,                 sonoma:        "f170744aeeffe657c8ae932a4ebaa760bf8c61da96b531a26594aa11c30464f7"
    sha256 cellar: :any,                 ventura:       "aa6db104afd1942a545768bafc17b15001ddfdf21f309a07d02853695ba4a394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e01f0637fee4dd36e60ddcc99b0334b7a98a8c02e6a6de58e97c9654ba1ed73"
  end

  head do
    url "https:git.osgeo.orggiteapostgispostgis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  depends_on "gdal"
  depends_on "geos"
  depends_on "icu4c@76"
  depends_on "json-c"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "pcre2"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "sfcgal"

  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  def postgresqls
    deps.filter_map { |dep| dep.to_formula if dep.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    # C++17 is required.
    ENV.append "CXXFLAGS", "-std=c++17"
    # Avoid linking to libc++ on Linux due to indirect LLVM dependency
    ENV["ac_cv_lib_cpp_main"] = "no" if OS.linux?

    bin.mkpath
    system ".autogen.sh" if build.head?

    postgresqls.each do |postgresql|
      # PostGIS' build system assumes it is being installed to the same place as
      # PostgreSQL, and looks for the `postgres` binary relative to the
      # installation `bindir`. We gently support this system using an illusion.
      #
      # PostGIS links against the `postgres` binary for symbols that aren't
      # exported in the public libraries `libpgcommon.a` and similar, so the
      # build will break with confusing errors if this is omitted.
      #
      # See: https:github.comNixOSnixpkgscommit330fff02a675f389f429d872a590ed65fc93aedb
      bin.install_symlink postgresql.opt_bin"postgres"

      mkdir "build-pg#{postgresql.version.major}" do
        system "..configure", "--with-projdir=#{Formula["proj"].opt_prefix}",
                               "--with-jsondir=#{Formula["json-c"].opt_prefix}",
                               "--with-pgconfig=#{postgresql.opt_bin}pg_config",
                               "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}",
                               *std_configure_args
        # Force `binpgsql2shp` to link to `libpq`
        system "make", "PGSQL_FE_CPPFLAGS=-I#{Formula["libpq"].opt_include}",
                       "PGSQL_FE_LDFLAGS=-L#{Formula["libpq"].opt_lib} -lpq"
        # Override the hardcoded install paths set by the PGXS makefiles
        system "make", "install", "bindir=#{bin}",
                                  "docdir=#{doc}",
                                  "mandir=#{man}",
                                  "pkglibdir=#{libpostgresql.name}",
                                  "datadir=#{sharepostgresql.name}",
                                  "PG_SHAREDIR=#{sharepostgresql.name}"
      end

      rm(bin"postgres")
    end

    # Extension scripts
    bin.install %w[
      utilscreate_upgrade.pl
      utilsprofile_intersects.pl
      utilstest_estimation.pl
      utilstest_geography_estimation.pl
      utilstest_geography_joinestimation.pl
      utilstest_joinestimation.pl
    ]
  end

  test do
    ENV["LC_ALL"] = "C"
    require "base64"
    (testpath"brew.shp").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoOgDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAEAAAASCwAAAAAAAAAAAPAAAAAAAAA8D8AAAAAAAAA
      AAAAAAAAAAAAAAAAAgAAABILAAAAAAAAAAAACEAAAAAAAADwPwAAAAAAAAAA
      AAAAAAAAAAAAAAADAAAAEgsAAAAAAAAAAAAQQAAAAAAAAAhAAAAAAAAAAAAA
      AAAAAAAAAAAAAAQAAAASCwAAAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAAAAA
      AAAAAAAAAAAABQAAABILAAAAAAAAAAAAAAAAAAAAAAAUQAAAAAAAACJAAAAA
      AAAAAEA=
    EOS
    (testpath"brew.dbf").write ::Base64.decode64 <<~EOS
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
    (testpath"brew.shx").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARugDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAADIAAAASAAAASAAAABIAAABeAAAAEgAAAHQAAAASAAAA
      igAAABI=
    EOS

    result = shell_output("#{bin}shp2pgsql #{testpath}brew.shp")
    assert_match "Point", result
    assert_match "AddGeometryColumn", result

    postgresqls.each do |postgresql|
      pg_version = postgresql.version.major
      expected = 'PostGIS built for PostgreSQL % cannot be loaded in PostgreSQL %',\s+#{pg_version}\.\d,
      postgis_version = version.major_minor
      assert_match expected, (sharepostgresql.name"contribpostgis-#{postgis_version}postgis.sql").read

      pg_ctl = postgresql.opt_bin"pg_ctl"
      psql = postgresql.opt_bin"psql"
      port = free_port

      datadir = testpathpostgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'postgis-3'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"postgis\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end