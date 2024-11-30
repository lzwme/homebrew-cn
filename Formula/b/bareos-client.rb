class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https:www.bareos.com"
  url "https:github.combareosbareosarchiverefstagsRelease23.1.0.tar.gz"
  sha256 "8a4ae832317de4c160deaf378fa783ab3e259c92b16e961f93fc8d0ffbb59d5a"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sequoia: "a4c091f719cf913d0169dfc61c6776523e564ad188b4add942073d054c52f83e"
    sha256 arm64_sonoma:  "8e2c4f7ecdaa225201ad7c4b9868d131bdd8c254aab09cefe35b8dc1ea52ebc4"
    sha256 arm64_ventura: "8831342bc284a21691808595541813945fdec8496ee710b0404a132110b21dc5"
    sha256 sonoma:        "f0920e20d82df606382dd8c8e52460abb3f6aaa194d252e3963b0db415f0d366"
    sha256 ventura:       "0a9e16ca65e7ef2fe24fcf8e52ffb491f0bc473bf8a3479f46476d28b0b445c4"
    sha256 x86_64_linux:  "d7f7362086788f338fd137813a828685c72681ad176dac9e1e6cdfbaa7e4e64c"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"

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