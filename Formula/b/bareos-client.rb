class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https:www.bareos.com"
  url "https:github.combareosbareosarchiverefstagsRelease24.0.1.tar.gz"
  sha256 "8bc642ba8b96e5975251aa68c7529ac44f27e91ca1f0a0c2a059356761075efc"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sequoia: "b29347f35018fb95e04816cb91c4fcab7b0818c94975df87fc50fa77ffe3f967"
    sha256 arm64_sonoma:  "8d5be7d7a9e0f1fa91874ed15688f75b68f57395b0901f90d7247bb64ab35007"
    sha256 arm64_ventura: "ad9a62670f5816ad63e075788808aeef8de07bbadd08f45e18a585300189516f"
    sha256 sonoma:        "2acbbfaff90e57e6efb5dd4d7014995959784674477f2ba86d376b3bf7e24609"
    sha256 ventura:       "669991fa52951fcb757226d23df6d78834dd34bae10863d2f494023bf1065356"
    sha256 arm64_linux:   "ffcb126c000e1176f62302af353bf84b1534d3902d093b6f896b922540677c28"
    sha256 x86_64_linux:  "d8de68039c06cd98fabbd0eba0bfd779ca013682ff1bcfc8ede1997609acf7f7"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "fmt" => :build
  depends_on "utf8cpp" => :build
  depends_on "jansson"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "bacula-fd", because: "both install a `bconsole` executable"

  def install
    # Work around Linux build failure by disabling warnings:
    # lmdbmdb.c:2282:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
    # fastlzlib.c:512:63: error: unused parameter ‘output_length’ [-Werror=unused-parameter]
    # Upstream issue: https:bugs.bareos.orgview.php?id=1504
    if OS.linux?
      ENV.append_to_cflags "-Wno-unused-but-set-variable"
      ENV.append_to_cflags "-Wno-unused-parameter"
    end

    # Work around hardcoded paths forced static linkage on macOS
    inreplace "corecmakeBareosFindAllLibraries.cmake" do |s|
      s.gsub! "set(OPENSSL_USE_STATIC_LIBS 1)", ""
      s.gsub! "${HOMEBREW_PREFIX}optlzolibliblzo2.a", Formula["lzo"].opt_libshared_library("liblzo2")
    end

    inreplace "corecmakeFindReadline.cmake",
              "${HOMEBREW_PREFIX}optreadlineliblibreadline.a",
              Formula["readline"].opt_libshared_library("libreadline")

    inreplace "coresrcfiledCMakeLists.txt",
              "bareos-fd PROPERTIES INSTALL_RPATH \"@loader_path..${libdir}\"",
              "bareos-fd PROPERTIES INSTALL_RPATH \"${libdir}\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_PYTHON=OFF",
                    "-Dworkingdir=#{var}libbareos",
                    "-Darchivedir=#{var}bareos",
                    "-Dconfdir=#{etc}bareos",
                    "-Dconfigtemplatedir=#{lib}bareosdefaultconfigs",
                    "-Dscriptdir=#{lib}bareosscripts",
                    "-Dplugindir=#{lib}bareosplugins",
                    "-Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                    "-Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                    "-Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dclient-only=ON",
                    "-DENABLE_LZO=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var"libbareos").mkpath
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc"bareosbareos-fd.d").exist?
      system lib"bareosscriptsbareos-config", "deploy_config",
             lib"bareosdefaultconfigs", etc"bareos", "bareos-fd"
      system lib"bareosscriptsbareos-config", "deploy_config",
             lib"bareosdefaultconfigs", etc"bareos", "bconsole"
    end
  end

  service do
    run [opt_sbin"bareos-fd", "-f"]
    require_root true
    log_path var"runbareos-fd.log"
    error_log_path var"runbareos-fd.log"
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}bareos-fd -? 2>&1")
    # Check if the configuration is valid.
    system sbin"bareos-fd", "-t"
  end
end