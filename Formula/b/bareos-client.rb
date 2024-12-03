class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https:www.bareos.com"
  url "https:github.combareosbareosarchiverefstagsRelease23.1.1.tar.gz"
  sha256 "468fbe12a509b65ca3de5041a901eb0cf1da5c9a4f1729ca57ed39f45fd428e7"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sequoia: "2ad752307a647086463caa7c0c66392a19963b963e76c6278a4303581ea82ee3"
    sha256 arm64_sonoma:  "cf629a37f5340eb00e82b38136c78d59a86353f8a0ca013645a3f331563d581b"
    sha256 arm64_ventura: "945c8b7a8c7a61b923eaad54f22cf9e3106d7b7e9a18049626e559511a2deaeb"
    sha256 sonoma:        "95fab9a2bdfc872b0bc5ffec51149d57aa7151a9f868216f646d4a4e443be511"
    sha256 ventura:       "5e7eb17048a2087046dc9c4bfbee31bd463a88098d5fd7fae8186815e38469a5"
    sha256 x86_64_linux:  "d7ac818be759920e3a5fe1f97a167245fb5e2f5399ee7ddd3ad639a776449385"
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