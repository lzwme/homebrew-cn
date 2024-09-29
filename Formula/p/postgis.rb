class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https:postgis.net"
  url "https:download.osgeo.orgpostgissourcepostgis-3.5.0.tar.gz"
  sha256 "ca698a22cc2b2b3467ac4e063b43a28413f3004ddd505bdccdd74c56a647f510"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:download.osgeo.orgpostgissource"
    regex(href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "fa7199217cdc71a7fc459885f47146dcbfe831633bbc6e3a916ffc37655d9bcf"
    sha256 cellar: :any,                 arm64_sonoma:  "45eeb9f286dc8a028c22360a27a796b008fd0347719edaa5a9402515dc3231f6"
    sha256 cellar: :any,                 arm64_ventura: "8239b9230b45ca7e0a997484aac90cbcfb81b47c519e04410381a9306a783f08"
    sha256 cellar: :any,                 sonoma:        "575a907d23cdc03ec9953710f401f7b14330b015a0173d30158642e6de439be2"
    sha256 cellar: :any,                 ventura:       "f1de61b9a2b443d283f65dcc32c4653a32f5092998c9f3985a9c4e51308be6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5537ac18cccf61c1ab51c11927584102c112ff4484d3093ac4cc897789513ed"
  end

  head do
    url "https:git.osgeo.orggiteapostgispostgis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  depends_on "gdal"
  depends_on "geos"
  depends_on "icu4c"
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

  on_linux do
    depends_on "llvm@18" # align with `apache-arrow`
  end

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    # C++17 is required.
    ENV.append "CXXFLAGS", "-std=c++17"

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