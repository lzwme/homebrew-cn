class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https:postgis.net"
  url "https:download.osgeo.orgpostgissourcepostgis-3.4.3.tar.gz"
  sha256 "f8ded505daeb8f57659da2b9e577ff71e183aaa094708d2eece2c56d93361f62"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:download.osgeo.orgpostgissource"
    regex(href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "619e7996364ce78a8c9f34c7762e493be62f0e9467104ff1bf61fa2842266b09"
    sha256 cellar: :any,                 arm64_ventura:  "1e7641421667a2d99c44032994c66344cab61570b4b9c6c1066702f454f33f94"
    sha256 cellar: :any,                 arm64_monterey: "beedaffb06905e360eb99351e442f377f91f345e81bdcc7ee7f16bcba1e2a6de"
    sha256 cellar: :any,                 sonoma:         "c50e0f3b10aea94825f983d75691cf231a0d47c681cd09ce17cd4cb2cc66ea4e"
    sha256 cellar: :any,                 ventura:        "b606bc9a70e7a1eafb1c84c7a9e8a9e16b523ee836c1e8e4506f2df9d86636f5"
    sha256 cellar: :any,                 monterey:       "f93e41a5b70d007775c51a065d103860ffbf661cc088df194b2217d7da2ffb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ec53c8041183126f144dd8628f330cd5f2b6a6a7ed9a92d096315e35f957cc"
  end

  head do
    url "https:git.osgeo.orggiteapostgispostgis.git", branch: "master"

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
  depends_on "libxml2"
  depends_on "pcre2"
  depends_on "postgresql@14"
  depends_on "proj"
  depends_on "protobuf-c" # for MVT (map vector tiles) support
  depends_on "sfcgal" # for advanced 2D3D functions

  uses_from_macos "llvm"

  on_linux do
    depends_on "libpq"
  end

  fails_with gcc: "5" # C++17

  def postgresql
    Formula["postgresql@14"]
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

    ENV.deparallelize

    # C++17 is required.
    ENV.append "CXXFLAGS", "-std=c++17"

    # Workaround for: Built-in generator --c_out specifies a maximum edition
    # PROTO3 which is not the protoc maximum 2023.
    # Remove when fixed in `protobuf-c`:
    # https:github.comprotobuf-cprotobuf-cpull711
    ENV["PROTOCC"] = Formula["protobuf"].opt_bin"protoc"

    # PostGIS' build system assumes it is being installed to the same place as
    # PostgreSQL, and looks for the `postgres` binary relative to the
    # installation `bindir`. We gently support this system using an illusion.
    #
    # PostGIS links against the `postgres` binary for symbols that aren't
    # exported in the public libraries `libpgcommon.a` and similar, so the
    # build will break with confusing errors if this is omitted.
    #
    # See: https:github.comNixOSnixpkgscommit330fff02a675f389f429d872a590ed65fc93aedb
    bin.mkpath
    ln_s "#{postgresql.opt_bin}postgres", "#{bin}postgres"

    args = [
      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      "--with-pgconfig=#{postgresql.opt_bin}pg_config",
      "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls",
    ]

    system ".autogen.sh" if build.head?
    system ".configure", *args, *std_configure_args
    system "make"
    # Override the hardcoded install paths set by the PGXS makefiles
    system "make", "install", "bindir=#{bin}",
                              "docdir=#{doc}",
                              "mandir=#{man}",
                              "pkglibdir=#{libpostgresql.name}",
                              "datadir=#{sharepostgresql.name}",
                              "PG_SHAREDIR=#{sharepostgresql.name}"

    rm "#{bin}postgres"

    # Extension scripts
    bin.install %w[
      utilscreate_upgrade.pl
      utilspostgis_restore.pl
      utilsprofile_intersects.pl
      utilstest_estimation.pl
      utilstest_geography_estimation.pl
      utilstest_geography_joinestimation.pl
      utilstest_joinestimation.pl
    ]
  end

  test do
    pg_version = postgresql.version.major
    expected = 'PostGIS built for PostgreSQL % cannot be loaded in PostgreSQL %',\s+#{pg_version}\.\d,
    postgis_version = Formula["postgis"].version.major_minor
    assert_match expected, (sharepostgresql.name"contribpostgis-#{postgis_version}postgis.sql").read

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

    pg_ctl = postgresql.opt_bin"pg_ctl"
    psql = postgresql.opt_bin"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'postgis-3'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"postgis\";", "postgres"
    system pg_ctl, "stop", "-D", testpath"test"
  end
end