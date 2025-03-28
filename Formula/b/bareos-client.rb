class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https:www.bareos.com"
  url "https:github.combareosbareosarchiverefstagsRelease24.0.2.tar.gz"
  sha256 "eaed6c4456e19eaeda7143caa73c167885b05f34f2ae39242b8c7f0a0d13f7c5"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sequoia: "ec44466352baadaee81f531905db44f97347f94f5f6d3582c16dc7044ffb5d46"
    sha256 arm64_sonoma:  "fdf345fbd3a064dcbf00e3141bad5c8ff6e77eaf895498a9ab586b734bb732dd"
    sha256 arm64_ventura: "f7cf406c090fa0d4ec4a56e4fd1b53427b667245da512e071e70b71b67fded37"
    sha256 sonoma:        "134027b83701c11d997d09d7d2bdeb844608f7cf0221d726c38125f5fa8f3c1c"
    sha256 ventura:       "0ed7c3796917441c54d20f8f30bd8902bc5313afd92606d35c784a1d0ca443b2"
    sha256 arm64_linux:   "fa54ef1fa244f5e4b2e93509ab2b1bfac6892c909a939745c84efa1532176797"
    sha256 x86_64_linux:  "ebf9c2185457ce2fa622eccd2b2c9abddea79da300fdfe5566105ca216e3f028"
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